class AddTaxRuleIdsToTableTax < ActiveRecord::Migration[5.0]
  def change
  	add_column :table_taxes, :tax_rule_ids, :integer, array: true, default: []
  end
end
