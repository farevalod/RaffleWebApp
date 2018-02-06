json.extract! admin, :id, :name, :user_name, :phone_number, :email, :confirm_token, :email_confirmed, :institution_id, :admin_level, :created_at, :updated_at
json.url admin_url(admin, format: :json)
