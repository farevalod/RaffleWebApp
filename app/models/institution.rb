class Institution < ApplicationRecord
  has_many :groups
  has_many :books
  validates :name, :tickets_per_book, :books_per_seller, :draw_date, :ticket_price, :max_books_per_seller, presence: true
end