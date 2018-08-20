class AddStatusToTableTax < ActiveRecord::Migration[5.0]
  def change
  	add_column :table_taxes, :status, :string
  end
end
