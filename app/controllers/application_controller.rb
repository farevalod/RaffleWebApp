class ApplicationController < ActionController::Base
  before_action :authorize
  # after_action :set_last_page_visited
  protect_from_forgery with: :exception

  protected

  def authorize
    unless Seller.find_by(id: session[:user_id]) or Admin.find_by(id: session[:admin_id])
      redirect_to main_page_url, notice: "Please log in"
    end
  end

  def authorize_admin
    unless Admin.find_by(id: session[:admin_id])
      redirect_to main_page_url, notice: "Necesitas permisos de administrador de institución"
    end
  end

  def authorize_seller_s_admin
    admin = Admin.find_by(id: session[:admin_id])
    if admin
      if admin.admin_level == 3 or admin.admin_level == 4
        redirect_to institution_url(admin.institution.id), notice: "Los administrdores de instituciones no poseen boletos"
      end
    end
  end

  def set_last_page_visited
    session[:previous_page] = "#{request.original_url}"
  end

end
