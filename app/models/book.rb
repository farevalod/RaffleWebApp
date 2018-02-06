class Book < ApplicationRecord
  belongs_to :seller
  belongs_to :institution
  has_many :tickets
  validates :num_in_institution, presence: true

  def create_tickets
    # Recupera la cantidad de boletos por talonario que se especificó en la institución.
    num = seller.group.institution.tickets_per_book

    # Para cada talonario se crea la cantidad de boletos que se definió en la institución.
    num.times do |i|
      Ticket.create(num_in_book: i+1, book_id: id)
    end
  end

end
