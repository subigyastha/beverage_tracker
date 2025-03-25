class CreateSymptoms < ActiveRecord::Migration[8.0]
  def change
    create_table :symptoms do |t|
      t.references :beverage, null: false, foreign_key: true
      t.boolean :occurred
      t.string :name
      t.string :severity
      t.string :timing

      t.timestamps
    end
  end
end
