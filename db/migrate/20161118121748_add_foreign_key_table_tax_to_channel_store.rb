class AddForeignKeyTableTaxToChannelStore < ActiveRecord::Migration[5.0]
  def change
  	add_reference :channel_stores, :table_tax, foreign_key: true
  end
end
