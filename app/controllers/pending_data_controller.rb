class PendingDataController < ApplicationController
  skip_before_action :authorize

  # def new
  # end

  def create
    seller = Seller.find(params[:seller_id])
    # Corrobora que no se hayan modificado los parametos de la URL. A futuro enviar la información el cookies privadas.
    if seller.user_name == params[:user_name]
      if seller.email_confirmed
        redirect_to login_url, notice: "Este usuario ya se encuentra activado."
      else
        seller.update(email: params[:email], phone_number: params[:phone_number])
        SellerMailer.registration_confirmation(seller).deliver
        flash[:success] = "Se te enviará un email para confirmar tu cuenta."
        redirect_to login_url
      end
    else
      # Mensaje ambiguo para despistar psibles ataques:
      redirect_to login_url, notice: "El usuario no existe o este email ya fue confirmado."
    end
  end
end
