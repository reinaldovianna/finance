class AddForegnKeyBankSplipToRevenues < ActiveRecord::Migration[5.0]
  def change
  	add_reference :revenues, :bank_slip, foreign_key: true
  end
end
