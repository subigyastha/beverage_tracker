# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_24_212944) do
  create_table "additions", force: :cascade do |t|
    t.integer "beverage_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["beverage_id"], name: "index_additions_on_beverage_id"
  end

  create_table "beverages", force: :cascade do |t|
    t.date "date"
    t.time "consumption_time"
    t.string "category"
    t.string "subcategory"
    t.float "quantity"
    t.string "unit"
    t.string "temperature"
    t.string "photo"
    t.integer "calories"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.integer "beverage_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["beverage_id"], name: "index_notes_on_beverage_id"
  end

  create_table "symptoms", force: :cascade do |t|
    t.integer "beverage_id", null: false
    t.boolean "occurred"
    t.string "name"
    t.string "severity"
    t.string "timing"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["beverage_id"], name: "index_symptoms_on_beverage_id"
  end

  add_foreign_key "additions", "beverages"
  add_foreign_key "notes", "beverages"
  add_foreign_key "symptoms", "beverages"
end
