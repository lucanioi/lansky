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

ActiveRecord::Schema[7.1].define(version: 2023_12_06_001722) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "budgets", force: :cascade do |t|
    t.datetime "period_start"
    t.datetime "period_end"
    t.integer "amount_in_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_budgets_on_user_id"
  end

  create_table "spending_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spendings", force: :cascade do |t|
    t.bigint "spending_category_id", null: false
    t.integer "amount_in_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "spent_at"
    t.bigint "user_id"
    t.index ["spending_category_id"], name: "index_spendings_on_spending_category_id"
    t.index ["user_id"], name: "index_spendings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "timezone", default: "UTC", null: false
  end

  add_foreign_key "budgets", "users"
  add_foreign_key "spendings", "spending_categories"
  add_foreign_key "spendings", "users"
end
