class Group < ApplicationRecord
  belongs_to :institution
  has_many :sellers
  validates :name, presence: true

  def tickets_sold
    sold = 0
    Seller.where(group_id: id).each do |seller|
      sold += seller.tickets_sold
    end
    sold
  end

  def books_sold
    sold = 0
    Seller.where(group_id: id).each do |seller|
      sold += seller.books_sold
    end
    sold
  end

  def sellers_quantity
    Seller.where(group_id: id).count
  end

  def self.select_groups_to_show(admin_id)
    admin = Admin.find_by(id: admin_id)
    if admin
      case admin.admin_level
        when 1 .. 2
          groups = Group.all
        when 3 .. 4
          groups = Group.where(institution_id: admin.institution.id)
      end
    end
    return groups, admin.admin_level
  end



end
