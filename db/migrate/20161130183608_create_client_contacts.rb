class CreateClientContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :client_contacts do |t|
      t.string :name
      t.string :email
      t.string :phone
    end
  end
end
