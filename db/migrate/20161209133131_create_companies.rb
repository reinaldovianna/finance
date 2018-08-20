class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|

      t.timestamps
    end

    add_reference :companies, :cnpj, foreign_key: true
  end
end
