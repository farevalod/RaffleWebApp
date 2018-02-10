class Admin < ApplicationRecord
  belongs_to :institution
  has_secure_password

  def text_admin_level
    if admin_level == 3
      return "Primario"
    elif admin_level == 4
      return "Secundario"
    end
  end
  
  def self.select_admins_to_show(admin_id)
    admin = Admin.find_by(id: admin_id)
    if admin
      case admin.admin_level
        when 1 .. 2
          num = 1
          admins = Admin.all
        when 3 .. 4
          num = 2
          admins = Admin.where(institution_id: admin.institution.id)
      end
      return admins, num
    end
  end
end
