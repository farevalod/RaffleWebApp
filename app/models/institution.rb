class Institution < ApplicationRecord
  has_many :groups
  has_many :books
  has_many :sellers
  has_many :admins
  validates :name, :tickets_per_book, :books_per_seller, :draw_date, :ticket_price, :max_books_per_seller, presence: true

  def tickets_sold
    sold = 0
    Group.where(institution_id: id).each do |group|
      sold += group.tickets_sold
    end
    sold
  end

  def books_sold
    sold = 0
    Group.where(institution_id: id).each do |group|
      sold += group.books_sold
    end
    sold
  end
  
  def sellers_quantity
    Seller.where(institution_id: id).count
  end
  
  def tickets_paid
    paid = 0
    Seller.where(institution_id: id).each do |seller|
      paid += seller.tickets_paid
    end
    paid
  end

  def groups_count
    Group.where(institution_id: id).count
  end

  def admins_count
    Admin.where(institution_id: id).count
  end
  
end