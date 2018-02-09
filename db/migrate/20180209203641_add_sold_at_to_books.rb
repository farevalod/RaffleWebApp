class AddSoldAtToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :sold_at, :datetime
  end
end
