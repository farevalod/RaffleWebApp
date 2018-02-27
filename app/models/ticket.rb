class Ticket < ApplicationRecord
  belongs_to :book
  validates :num_in_book, presence: true
  validates :phone_number, numericality:  {greater_than_or_equal_to: 11111111, allow_blank: true}
  validates :phone_number, numericality:  {less_than_or_equal_to: 99999999999, allow_blank: true}
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => true
  delegate :seller_id, to: :book

  def sell(name, email, phone_number)
    parameters = { name: name.titleize, email: email,
                   phone_number: phone_number, sold: true, sold_at: DateTime.now }
    update(parameters)
    if book.tickets.all? &:sold
      book.update(sold: true, sold_at: DateTime.now)
    end
  end

  def self.set_corresponding_ticket(ticket_id, admin_id, user_id)
    # El caso en que no es vendedor o super admin está cubierto por authorize_seller_s_admin
    admin = Admin.find_by(id: admin_id)
    ticket = self.find(ticket_id)
    if admin or ticket.seller_id = user_id
      return ticket
    end
  end


end
