json.extract! seller, :id, :name, :rut, :email, :phone_number, :num_in_institution, :num_of_logins, :email_confirmed, :confirm_token, :created_at, :updated_at
json.url seller_url(seller, format: :json)
