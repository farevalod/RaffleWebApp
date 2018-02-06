class AddUserNameToSellers < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :user_name, :string
  end
end
