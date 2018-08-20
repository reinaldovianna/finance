class RemoveForegnKeyBankSplipToRevenues < ActiveRecord::Migration[5.0]
  def change
  	remove_foreign_key :revenues, :bank_slips
  end
end
