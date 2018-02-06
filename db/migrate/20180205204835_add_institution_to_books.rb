class AddInstitutionToBooks < ActiveRecord::Migration[5.1]
  def change
    add_reference :books, :institution, foreign_key: true
  end
end
