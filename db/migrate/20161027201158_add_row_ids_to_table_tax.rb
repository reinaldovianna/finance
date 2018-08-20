class AddRowIdsToTableTax < ActiveRecord::Migration[5.0]
  def change
    add_column :table_taxes, :row_ids, :integer, array: true, default: []
  end
end
