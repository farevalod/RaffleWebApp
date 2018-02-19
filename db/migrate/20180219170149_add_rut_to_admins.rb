class AddRutToAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :rut, :string
  end
end
