class AdminSessionsController < ApplicationController
  skip_before_action :authorize, only: [:new,:create]

  def new
    if session[:user_id] or session[:admin_id]
      redirect_to main_page_url, notice: "Actualmente hay una sesión iniciada"
    end
  end

  def create
    user_name = remove_non_alnum(remove_accent_marks(params[:user_name])).downcase
    user = Admin.find_by(user_name: user_name)
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
