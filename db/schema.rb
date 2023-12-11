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

ActiveRecord::Schema[7.1].define(version: 2023_12_11_104614) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "budgets", force: :cascade do |t|
    t.datetime "period_start"
    t.datetime "period_end"
    t.integer "amount_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_budgets_on_user_id"
  end

  create_table "ledger_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ledger_categories_on_name", unique: true
  end

  create_table "ledger_entries", force: :cascade do |t|
    t.integer "amount_cents"
    t.bigint "ledger_category_id", null: false
    t.bigint "user_id", null: false
    t.integer "entry_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "recorded_at"
    t.index ["entry_type"], name: "index_ledger_entries_on_entry_type"
    t.index ["ledger_category_id"], name: "index_ledger_entries_on_ledger_category_id"
    t.index ["user_id"], name: "index_ledger_entries_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "timezone", default: "UTC", null: false
    t.string "currency"
    t.boolean "test_user", default: false
    t.integer "chatbot_mode", default: 1, null: false
    t.index ["phone"], name: "index_users_on_phone", unique: true
  end

  add_foreign_key "budgets", "users"
  add_foreign_key "ledger_entries", "ledger_categories"
  add_foreign_key "ledger_entries", "users"
end
