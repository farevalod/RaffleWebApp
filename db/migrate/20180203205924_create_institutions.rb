class CreateInstitutions < ActiveRecord::Migration[5.1]
  def change
    create_table :institutions do |t|
      t.string :name
      t.integer :tickets_per_book
      t.integer :books_per_seller
      t.string :draw_date
      t.integer :ticket_price
      t.integer :max_books_per_seller

      t.timestamps
    end
  end
end
