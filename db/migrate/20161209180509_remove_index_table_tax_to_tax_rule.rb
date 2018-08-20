class RemoveIndexTableTaxToTaxRule < ActiveRecord::Migration[5.0]
  def change
  	remove_index :tax_rules, :table_tax_id
  end
end
