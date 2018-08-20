class CreateCnpjs < ActiveRecord::Migration[5.0]
  def change
    create_table :cnpjs do |t|
      t.string :vat_number
      t.string :company_name
      t.string :trading_name
      t.string :street_address
      t.string :neighborhood_address
      t.string :city_address
      t.string :uf_address
      t.string :detail_address
      t.string :cep_address
      t.string :email
      t.string :phone
      t.string :situation
      t.date :situation_date
      t.string :type
      t.string :legal_nature
      t.date :opening_date

      t.timestamps
    end
  end
end
