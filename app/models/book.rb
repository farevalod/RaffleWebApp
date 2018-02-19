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

  def self.select_books_to_show(admin_id, user_id)
    admin = Admin.find_by(id: admin_id)
    if admin
      case admin.admin_level
        when 1 .. 2
          num = 1
          books = Book.all
        when 3 .. 4
          num = 2
          books = Book.where(institution_id: admin.institution.id)
      end
    else
      num = 3
      books = Book.where(seller_id: user_id)
      # Cuando no hay ni admin ni user esta cubierto por el before_action: authorize
    end
    [books, num]
  end

  def self.set_corresponding_book(book_id, admin_id, user_id)
    # El caso en que no es usuario está cubierto por authorize
    admin = Admin.find_by(id: admin_id)
    book = self.find(book_id)

    if admin
      ad_lv = admin.admin_level
      if ad_lv.between?(1, 2) or (ad_lv.between?(3, 4) and admin.institution.books.include?(book))
        return book
      end
    else
      seller = Seller.find_by(id: user_id)
      if seller.books.include?(book)
        return book
      end
    end
  end

  def tickets_sold
    Ticket.where(book_id: id).where(sold: true).count
  end

  def tickets_paid
    Ticket.where(book_id: id).where(paid: true).count
  end


end