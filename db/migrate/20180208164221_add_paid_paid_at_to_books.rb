class AddPaidPaidAtToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :paid, :boolean
    add_column :books, :paid_at, :datetime
  end
end
