class CreateBankSlipStatus < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_slip_statuses do |t|
      t.integer :sequence_sts
      t.string :name
    end
  end
end
