class AddColumnsToClient < ActiveRecord::Migration[5.0]
  def change
  	add_column :clients, :monthly_payment, :float
    add_column :clients, :payday, :integer
    add_column :clients, :additional_time_day, :integer
    add_column :clients, :additional_time_day_based, :string
  end
end
