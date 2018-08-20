class AddForeignKeyClientToClientContact < ActiveRecord::Migration[5.0]
  def change
  	add_reference :client_contacts, :client, foreign_key: true
  end
end