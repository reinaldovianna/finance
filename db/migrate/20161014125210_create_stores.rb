class CreateStores < ActiveRecord::Migration[5.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end
