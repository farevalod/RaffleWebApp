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
      # Si es super admin ve todos los admins:
      if admin.admin_level.in? [1,2]
        Admin.all
      # Si es admin de institución solo ve los admins de la institución:
      elsif admin.admin_level.in? [3,4]
        institution.admins
      end
    else
      raise "No Admin Found" 
    end
  end

  def self.set_corresponding_admin(admin_id_param, admin_id)
    # El caso en que no es admin está cubierto por authorize_admin
    # El caso en que no es usuario esta cubierto por authorize
    admin = Admin.find(admin_id)
    admin_2 = Admin.find(admin_id_param)
    if admin.admin_level.in? [1,2] or admin_2.in? admin.institution.admins
      admin_2
    else
      raise "No Admin Found"
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
