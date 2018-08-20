class AddCnpjUniqueIndexVatNumber < ActiveRecord::Migration[5.0]
  def change
  	add_index :cnpjs, :vat_number, unique: true
  end
end
