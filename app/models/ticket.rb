class Ticket < ApplicationRecord
  belongs_to :book
  validates :num_in_book, presence: true
  validates :phone_number, numericality:  {greater_than_or_equal_to: 11111111, allow_blank: true}
  validates :phone_number, numericality:  {less_than_or_equal_to: 99999999999, allow_blank: true}
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => true
end
