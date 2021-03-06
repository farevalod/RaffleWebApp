class Seller < ApplicationRecord
  belongs_to :institution
  belongs_to :group
  # http://guides.rubyonrails.org/association_basics.html
  # dependent: destroy
  has_many :books, dependent: :destroy
  has_many :tickets, through: :books
  before_create :confirmation_token
  has_secure_password
  validates :name, :rut, :password_digest, presence: true

  private
  def confirmation_token
    if confirm_token.blank?
      confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

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
  def modify_user_name
    coincidences_count = (Seller.where(institution_id: institution_id).where(name: name).count - 1)
    unless coincidences_count.zero?
      new_user_name = user_name += coincidences_count.to_s
      update(user_name: new_user_name )
    end
  end

  public

  # Este metodo se usa para evitar tener varios métodos del modelo en la acción create del controlador.
  def init_seller
    create_initial_books
    modify_user_name
  end

  def tickets_sold
    books.flat_map(&:tickets).select(&:sold).count
  end

  def books_sold
    books.select(&:sold).count
  end

  def tickets_paid
    books.flat_map(&:tickets).select(&:paid).count
  end

  def books_paid
    books.select(&:paid).count
  end

  def self.select_sellers_to_show(admin)
    if admin
      case admin.admin_level
        when 1 .. 2
          sellers = Seller.all
        when 3 .. 4
          sellers = admin.institution.sellers
      end
    else
      raise "No Admin Found"
    end
    sellers
  end

  def self.set_corresponding_seller(seller_id, admin_id, user_id)
    # El caso en que no es admin está cubierto por authorize_admin
    admin = Admin.find_by(id: admin_id)
    seller = self.find(seller_id)

    if admin
      ad_lv = admin.admin_level
      if ad_lv.between?(1, 2) or (ad_lv.between?(3, 4) and admin.institution.sellers.include?(seller))
        return seller
      end
    elsif user_id == seller_id.to_i
      return seller
    end
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!
  end

end
