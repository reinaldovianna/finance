class CreateJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :channel_stores, :bank_slips do |t|
      t.index [:channel_store_id, :bank_slip_id], :name => 'channel_bank_slip_index'
      t.index [:bank_slip_id, :channel_store_id], :name => 'bank_slip_channel_index'
    end
  end
end
