class CreateTaxRules < ActiveRecord::Migration[5.0]
  def change
    create_table :tax_rules do |t|
      t.integer :row_ids, array: true, default: []
      t.string :operator
      t.string :measurement
      t.float :value

			t.timestamps
    end

    add_reference :tax_rules, :table_tax, foreign_key: true
  end
end