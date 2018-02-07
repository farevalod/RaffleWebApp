class AddSoldToTickets < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :sold, :boolean, default: false
  end
end
