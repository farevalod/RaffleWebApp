class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :user_name
      t.string :password_digest
      t.string :phone_number
      t.string :email
      t.string :confirm_token
      t.boolean :email_confirmed
      t.belongs_to :institution, foreign_key: true
      t.integer :admin_level

      t.timestamps
    end
  end
end
