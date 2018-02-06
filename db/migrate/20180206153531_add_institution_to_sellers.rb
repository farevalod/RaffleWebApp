class AddInstitutionToSellers < ActiveRecord::Migration[5.1]
  def change
    add_reference :sellers, :institution, foreign_key: true
  end
end
