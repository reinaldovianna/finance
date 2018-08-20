class AddFieldsToChannelStore < ActiveRecord::Migration[5.0]
  def change
  	add_column :channel_stores, :monthly_payment, :float
    add_column :channel_stores, :order_payment, :float
    add_column :channel_stores, :payday, :integer
    add_column :channel_stores, :additional_time_day, :integer
    add_column :channel_stores, :additional_time_day_based, :string
  end
end
