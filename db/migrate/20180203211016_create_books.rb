class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.integer :num_in_institution
      t.belongs_to :seller, foreign_key: true

      t.timestamps
    end
  end
end
