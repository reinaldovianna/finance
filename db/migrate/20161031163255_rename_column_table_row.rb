class RenameColumnTableRow < ActiveRecord::Migration[5.0]
  def change
  	rename_column :table_tax_rows, :type, :row_type
  	rename_column :table_tax_rows, :value, :row_value
  	rename_column :table_tax_rows, :name, :row_name
  	rename_column :table_tax_rows, :measurement, :row_measurement
  end
end
