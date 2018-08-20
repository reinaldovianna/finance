class AddCnpjIdToClient < ActiveRecord::Migration[5.0]
  def change
    add_reference :clients, :cnpj, foreign_key: true
  end
end
