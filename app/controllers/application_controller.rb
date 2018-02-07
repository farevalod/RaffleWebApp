class ApplicationController < ActionController::Base
  before_action :authorize
  protect_from_forgery with: :exception

  protected

  def authorize
    unless Seller.find_by(id: session[:user_id]) or Admin.find_by(id: session[:admin_id])
      redirect_to main_page_url, notice: "Please log in"
    end
  end

end
