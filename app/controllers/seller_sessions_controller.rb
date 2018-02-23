class SellerSessionsController < ApplicationController
  skip_before_action :authorize, only: [:new,:create]

  def new
    @pending_data = params[:pending_data]
    @name = params[:user_name]
  end

  def create
    user = Seller.find_by(user_name: params[:user_name])
    if user.try(:authenticate, params[:password])

      if user.email_confirmed
        session[:user_id] = user.id
        redirect_to books_url
      else
        redirect_to login_url(pending_data: true, seller_id: user.id, user_name: params[:user_name])
      end

    else
      redirect_to login_url, alert: "Combinación usuario/contraseña no válida."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to main_page_path, notice: "Sesión Cerrada"
  end
end
