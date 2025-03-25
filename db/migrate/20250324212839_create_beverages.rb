class CreateBeverages < ActiveRecord::Migration[8.0]
  def change
    create_table :beverages do |t|
      t.date :date
      t.time :consumption_time
      t.string :category
      t.string :subcategory
      t.float :quantity
      t.string :unit
      t.string :temperature
      t.string :photo
      t.integer :calories

      t.timestamps
    end
  end
end
