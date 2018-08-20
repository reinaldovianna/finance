class AddForegnKeyRevenueToBankSlips < ActiveRecord::Migration[5.0]
  def change
  	add_reference :bank_slips, :revenue, foreign_key: true
  end
end
