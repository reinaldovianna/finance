class RemoveUniqueIndexCnpj < ActiveRecord::Migration[5.0]
  def change
  	remove_index :cnpjs, :vat_number
  end
end
