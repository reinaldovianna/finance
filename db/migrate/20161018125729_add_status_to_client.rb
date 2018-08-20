class AddStatusToClient < ActiveRecord::Migration[5.0]
  def change
  	add_column :clients, :status, :string, :null => false
  end
end
