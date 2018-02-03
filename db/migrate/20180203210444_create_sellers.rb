class CreateSellers < ActiveRecord::Migration[5.1]
  def change
    create_table :sellers do |t|
      t.string :name
      t.string :rut
      t.string :password_digest
      t.string :email
      t.integer :phone_number
      t.integer :num_in_institution
      t.integer :num_of_logins
      t.boolean :email_confirmed, default: false
      t.string :confirm_token
      t.belongs_to :group, foreign_key: true

      t.timestamps
    end
  end
end
