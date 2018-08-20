class CreateTableTaxes < ActiveRecord::Migration[5.0]
  def change
    create_table :table_taxes do |t|
      t.string :name

      t.timestamps
    end
  end
end
