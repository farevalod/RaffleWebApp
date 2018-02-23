class Seller < ApplicationRecord
  belongs_to :institution
  belongs_to :group
  has_many :books
  before_create :confirmation_token
  has_secure_password
  validates :name, :rut, :password_digest, presence: true

  # Este metodo hace que se creen talonarios para el vendedor en base a la cantidad definida en la institución.
  def create_initial_books
    institution = group.institution
    books_per_seller =  institution.books_per_seller
    books_per_seller.times do
      new_book = Book.create(num_in_institution: institution.books.count + 1,
                  seller_id: id,
                  institution_id: institution.id
      )
      new_book.create_tickets
    end
  end

  # Metodo para general el nombre de usuario que el vendedor utilizará para iniciar sesión.
  def create_user_name
    user_name = name.downcase.delete(' ')
    while Seller.find_by(institution_id: institution_id, user_name: user_name)
      user_name += '1'
    end
    update( user_name: user_name )
  end

  # Este metodo se usa para evitar tener varios métodos del modelo en la acción create del controlador.
  def init_seller
    create_initial_books
    create_user_name
  end

  def del_seller_books_and_tickets
    # Este script elimina los talonario y los boletos asociados a un vendedor.
    # >>>>> OJO: RIESGOSO EN PRODUCCIÓN <<<<<
    books_ids = Book.where(seller_id: id).ids.uniq
    if books_ids.any?
      books_ids.each do |bid|
        Ticket.where(book_id: bid).destroy_all
      end
      Book.where(seller_id: id).destroy_all
    end
    destroy
  end

  def tickets_sold
    sold = 0
    Book.where(seller_id: id).each do |book|
      sold += Ticket.where(book_id: book.id).where(sold: true).count
    end
    sold
  end

  def books_sold
    Book.where(seller_id: id, sold: true).count
  end

  def tickets_paid
    paid = 0
    Book.where(seller_id: id).each do |book|
      paid += Ticket.where(book_id: book.id).where(paid: true).count
    end
    paid
  end

  def books_paid
    Book.where(seller_id: id, paid: true).count
  end

  def self.select_sellers_to_show(admin_id)
    admin = Admin.find_by(id: admin_id)
    if admin
      case admin.admin_level
        when 1 .. 2
          sellers = Seller.all
        when 3 .. 4
          sellers = Seller.where(institution_id: admin.institution.id)
      end
    end
     [sellers, admin.admin_level]
  end

  def self.set_corresponding_seller(seller_id, admin_id, user_id)
    # El caso en que no es admin está cubierto por authorize_admin
    admin = Admin.find_by(id: admin_id)
    seller = self.find(seller_id)
    puts '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'
    puts admin
    puts seller
    puts admin.admin_level
    puts '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'

    if admin
      ad_lv = admin.admin_level
      if ad_lv.between?(1, 2) or (ad_lv.between?(3, 4) and admin.institution.sellers.include?(seller))
        return seller
      end
    else
      if user_id == seller_id
        return seller
      end
    end
  end

  private
  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

  def seller_pending_data
  end

end
