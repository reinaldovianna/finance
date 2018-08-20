class AddClientToTableTaxes < ActiveRecord::Migration[5.0]
  def change
  	add_reference :table_taxes, :client, foreign_key: true
  end
end
