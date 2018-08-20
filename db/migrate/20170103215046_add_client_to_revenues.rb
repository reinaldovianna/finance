class AddClientToRevenues < ActiveRecord::Migration[5.0]
  def change
  	add_reference :revenues, :client, foreign_key: true
  end
end
