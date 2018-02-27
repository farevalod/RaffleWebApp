class Group < ApplicationRecord
  belongs_to :institution
  has_many :sellers
  validates :name, presence: true

  def tickets_sold
    sellers.map(&:tickets_sold).sum
  end

  def books_sold
    sellers.map(&:books_sold).sum
  end

  def sellers_quantity
    Seller.where(group_id: id).count
  end

  def self.select_groups_to_show(admin)
    if admin
      case admin.admin_level
        when 1 .. 2
          groups = Group.all
        when 3 .. 4
          groups = admin.institution.groups
      end
    end
    return groups
  end

  def self.set_corresponding_group(group_id, admin_id)
    admin = Admin.find(admin_id)
    group = self.find(group_id)
    # El caso en que no es admin está cubierto por authorize_admin
    # El caso en que no es usuario esta cubierto por authorize
    ad_lv = admin.admin_level
    if ad_lv.between?(1, 2) or (ad_lv.between?(3, 4) and admin.institution.groups.include?(group))
      self.find(group_id)
    end
  end

end
