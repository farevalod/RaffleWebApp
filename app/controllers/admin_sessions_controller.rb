class AdminSessionsController < ApplicationController
  skip_before_action :authorize, only: [:new,:create]

  def new
  end

  def create
    user = Admin.find_by(user_name: params[:user_name])
    if user.try(:authenticate, params[:password])
      if user.email_confirmed
        session[:admin_id] = user.id
        redirect_to institution_url(user.institution)
      else
        flash[:notice] = 'Please activate your account by following the
        instructions in the account confirmation email you received to proceed'
        render 'new'
      end
    else
      redirect_to login_admin_url, alert: 'Combinación usuario-contraseña inválida'
    end

  end

  def destroy
    session[:admin_id] = nil
    redirect_to main_page_url, notice: 'Sesión Cerrada'
  end
end
