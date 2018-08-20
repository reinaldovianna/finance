class AddForeignKeyCnpjToChannelStores < ActiveRecord::Migration[5.0]
  def change
  	add_reference :channel_stores, :cnpj, foreign_key: true
  end
end
