# Preview all emails at http://localhost:3000/rails/mailers/seller_mailer
class SellerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/seller_mailer/registration_confirmation
  def registration_confirmation
    SellerMailer.registration_confirmation
  end

end
