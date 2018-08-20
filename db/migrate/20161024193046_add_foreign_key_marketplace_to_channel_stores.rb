class AddForeignKeyMarketplaceToChannelStores < ActiveRecord::Migration[5.0]
  def change
  	add_reference :channel_stores, :marketplace, foreign_key: true
  end
end
