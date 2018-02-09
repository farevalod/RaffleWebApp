class AddSoldAtToTickets < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :sold_at, :datetime
  end
end
