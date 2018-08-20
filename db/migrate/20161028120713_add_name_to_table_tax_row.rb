class AddNameToTableTaxRow < ActiveRecord::Migration[5.0]
  def change
  	add_column :table_tax_rows, :name, :string
  end
end
