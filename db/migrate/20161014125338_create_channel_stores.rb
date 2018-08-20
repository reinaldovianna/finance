class CreateChannelStores < ActiveRecord::Migration[5.0]
  def change
    create_table :channel_stores do |t|
      t.string :name

      t.timestamps
    end
  end
end
