class AdminSessionsController < ApplicationController
  skip_before_action :authorize, only: [:new,:create]

  def new
  end

  def create
    user = Admin.find_by(user_name: params[:user_name])
    if user.try(:authenticate, params[:password])
      session[:admin_id] = user.id
      redirect_to institution_url(user.institution)
    else
      redirect_to login_admin_url, alert: 'Combinación usuario-contraseña inválida'
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to main_page_url, notice: 'Logged out'
  end
end
