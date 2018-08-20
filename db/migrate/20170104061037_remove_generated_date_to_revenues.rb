class RemoveGeneratedDateToRevenues < ActiveRecord::Migration[5.0]
  def change
  	remove_column :revenues, :generated_date
  end
end
