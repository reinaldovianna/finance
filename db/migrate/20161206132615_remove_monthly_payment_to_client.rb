class RemoveMonthlyPaymentToClient < ActiveRecord::Migration[5.0]
  def change
  	remove_column :clients, :monthly_payment
  end
end
