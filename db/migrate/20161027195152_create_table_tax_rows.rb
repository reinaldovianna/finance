class CreateTableTaxRows < ActiveRecord::Migration[5.0]
  def change
    create_table :table_tax_rows do |t|
      t.string :type
      t.string :measurement
      t.float :value

      t.timestamps
    end
  end
end
