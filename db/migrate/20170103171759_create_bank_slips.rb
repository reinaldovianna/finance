class CreateBankSlips < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_slips do |t|
      t.string :vat_number
      t.string :bank_code
      t.date :issued_date
      t.date :due_date
      t.date :paid_date
      t.date :canceled_date
      t.float :total_cost
      t.string :details

      t.timestamps
    end
  end

end
