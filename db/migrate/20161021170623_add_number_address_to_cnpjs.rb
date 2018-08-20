class AddNumberAddressToCnpjs < ActiveRecord::Migration[5.0]
  def change
    add_column :cnpjs, :number_address, :string
  end
end
