class AddStatusToChannelStoresAndStores < ActiveRecord::Migration[5.0]
  def change
  	add_column :channel_stores, :status, :string
  	add_column :stores, :status, :string
  end
end
