class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.string :name
      t.string :email
      t.integer :phone_number
      t.integer :num_in_book
      t.belongs_to :book, foreign_key: true

      t.timestamps
    end
  end
end
