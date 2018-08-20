class AddRowsToTableTax < ActiveRecord::Migration[5.0]
  def change
    add_column :table_taxes, :rows, :integer, array: true, default: []
  end
end
