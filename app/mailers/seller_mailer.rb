class SellerMailer < ApplicationMailer
  default from: "Software de Gestión de Rifas <gestionrifas@gmail.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.seller_mailer.registration_confirmation.subject
  #
  def registration_confirmation(seller, admin)
    @seller = seller
    @admin = admin
    mail(to: "#{seller.name} <#{seller.email}>", subject: "#{@admin.institution.name.upcase} - Registrate en la Rifa")
  end
end
