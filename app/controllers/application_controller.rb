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
      redirect_to main_page_url, notice: "Necesitas permisos de administrador"
    end
  end

  def set_last_page_visited
    session[:previous_page] = "#{request.original_url}"
  end

end
