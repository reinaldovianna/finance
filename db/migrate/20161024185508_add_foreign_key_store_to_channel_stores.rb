class AddForeignKeyStoreToChannelStores < ActiveRecord::Migration[5.0]
  def change
  	add_reference :channel_stores, :store, foreign_key: true
  end
end
