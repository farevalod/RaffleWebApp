class Institution < ApplicationRecord
  has_many :groups
  has_many :books
  has_many :sellers
  has_many :admins
  validates :name, :tickets_per_book, :books_per_seller, :draw_date, :ticket_price, :max_books_per_seller, presence: true

  def tickets_sold
    groups.map(&:tickets_sold).sum
  end

  def books_sold
    groups.map(&:books_sold).sum
  end

  def sellers_quantity
    sellers.count
  end

  def tickets_paid
    sellers.map(&:tickets_paid).sum
  end

  def groups_count
    groups.count
  end

  def admins_count
    admins.where(institution_id: id).count
  end

  def self.set_corresponding_institution(institution_id, admin_id)
    institution = Institution.find(institution_id)
    admin = Admin.find(admin_id)
    # El caso en que no es admin está cubierto por authorize_admin
    # El caso en que no es usuario esta cubierto por authorize
    if admin.admin_level.in? [1,2,3,4] and admin.in? institution.admins
      institution
    end
  end
end
