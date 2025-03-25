class CreateAdditions < ActiveRecord::Migration[8.0]
  def change
    create_table :additions do |t|
      t.references :beverage, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
