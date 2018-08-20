class AddClientToChannelStores < ActiveRecord::Migration[5.0]
  def change
  	add_reference :channel_stores, :client, foreign_key: true
  end
end
