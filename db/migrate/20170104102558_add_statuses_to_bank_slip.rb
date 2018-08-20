class AddStatusesToBankSlip < ActiveRecord::Migration[5.0]
  def change
  	add_reference :bank_slips, :bank_slip_status, foreign_key: true
  end
end
