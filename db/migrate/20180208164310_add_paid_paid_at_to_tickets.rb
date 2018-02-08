class AddPaidPaidAtToTickets < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :paid, :boolean
    add_column :tickets, :paid_at, :datetime
  end
end
