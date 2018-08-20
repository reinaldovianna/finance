class AddGeneratedDateToBankSlips < ActiveRecord::Migration[5.0]
  def change
  	add_column :bank_slips, :generated_date, :date
  end
end
