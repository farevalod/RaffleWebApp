class AddSoldToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :sold, :boolean, defult: false
  end
end
