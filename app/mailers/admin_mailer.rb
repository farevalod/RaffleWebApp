class AdminMailer < ApplicationMailer
  default from: 'Software de Gestión de Rifas <gestionrifas@gmail.com>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.registration_confirmation.subject

  def registration_confirmation(new_admin, old_admin)
    @new_admin = new_admin
    @old_admin = old_admin
    mail to: "#{new_admin.name} <#{new_admin.email}>", subject: "Registration Confirmation"
  end

end
