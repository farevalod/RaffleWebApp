class Admin < ApplicationRecord
  belongs_to :institution
  before_create :confirmation_token
  has_secure_password

  def text_admin_level
    if admin_level == 3
      "Primario"
    elsif admin_level == 4
      "Secundario"
    end
  end

  def self.select_admins_to_show(admin)
    if admin
      case admin.admin_level
        # Si es super admin ve todos los admins:
        when 1 .. 2
          num = 1
          admins = Admin.all
        # Si es admin de institución solo ve los admins de la institución:
        when 3 .. 4
          num = 2
          admins = institution.admins
      end
    else
      raise "No Admin Found" 
    end
    admins
  end

  def self.set_corresponding_admin(admin_id_param, admin_id)
    # El caso en que no es admin está cubierto por authorize_admin
    # El caso en que no es usuario esta cubierto por authorize
    admin = find(admin_id)
    admin_2 = find(admin_id_param)
    ad_lv = admin.admin_level
	# Los dos lados del if son iguales?
    if ad_lv.between?(1, 2)
      admin_2
    elsif admin.institution.admins.include?(admin_2)
      admin_2
    end
  end

  def email_activate
    email_confirmed = true
    confirm_token = nil
    save!
  end

  # Metodo para general el nombre de usuario que el vendedor utilizará para iniciar sesión.
  def modify_user_name
    coincidences_count = (Admin.where(institution_id: institution_id).where(name: name).count - 1)
    unless coincidences_count.zero?
      new_user_name = user_name += coincidences_count.to_s
      update(user_name: new_user_name )
    end
  end


  private

  def confirmation_token
    if confirm_token.blank?
      confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

end
