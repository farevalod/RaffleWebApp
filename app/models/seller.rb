class Seller < ApplicationRecord
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
    update( user_name: user_name )
  end

  # Este metodo se usa para evitar tener varios métodos del modelo en la acción create del controlador.
  def init_seller
    create_initial_books
    create_user_name
  end

end
