class AddClientToStores < ActiveRecord::Migration[5.0]
  def change
  	add_reference :stores, :client, foreign_key: true
  end
end
