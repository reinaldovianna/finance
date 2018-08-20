class CreateRevenues < ActiveRecord::Migration[5.0]
  def change
    create_table :revenues do |t|
      t.string :month
      t.string :year
      t.date :generated_date
      t.boolean :manually

      t.timestamps
    end    
  end

end
