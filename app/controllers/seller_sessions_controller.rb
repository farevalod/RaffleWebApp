class SellerSessionsController < ApplicationController
  def new
  end

  def create
    user = Seller.find_by(user_name: params[:user_name])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      redirect_to books_url
    else
      redirect_to login_url, alert: "Invalid user/password cobination"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to main_page_path, notice: "Logged out"
  end
end
