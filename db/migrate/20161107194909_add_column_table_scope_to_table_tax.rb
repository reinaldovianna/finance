class AddColumnTableScopeToTableTax < ActiveRecord::Migration[5.0]
  def change
  	add_column :table_taxes, :table_scope, :string
  end
end
