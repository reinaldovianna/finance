class DropBankSplip < ActiveRecord::Migration[5.0]
  def up
    drop_table 'bank_slips' if ActiveRecord::Base.connection.table_exists? 'bank_slips'
 
    if ActiveRecord::Base.connection.table_exists? :bank_slips
      drop_table :bank_slips
    end
  end
end
