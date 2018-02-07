class Seller < ApplicationRecord
  belongs_to :institution
  belongs_to :group
  has_many :books
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

  def calculate_tickets_sold
    sold = 0
    Book.where(seller_id: id).each do |book|
      sold += Ticket.where(book_id: book.id).where(sold: true).count
    end
    return sold #Por alguna razón al noponer el retun devolvía un ojeto
  end

  def calculate_books_sold
    Book.where(seller_id: id, sold: true).count
  end

end
