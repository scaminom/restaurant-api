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

ActiveRecord::Schema[7.1].define(version: 2023_12_15_061854) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", id: :string, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "email"
    t.string "phone"
    t.datetime "date"
    t.integer "id_type"
  end

  create_table "events", force: :cascade do |t|
    t.string "description"
    t.integer "event_type"
    t.datetime "occurred_at"
    t.bigint "user_id", null: false
    t.bigint "order_number", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "invoices", primary_key: "invoice_number", force: :cascade do |t|
    t.bigint "order_number"
    t.integer "payment_method"
    t.string "client_id", null: false
    t.index ["client_id"], name: "index_invoices_on_client_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "quantity"
    t.decimal "unit_price", precision: 8, scale: 3
    t.decimal "subtotal", precision: 10, scale: 2
    t.bigint "product_id", null: false
    t.bigint "order_number", null: false
    t.integer "status"
    t.index ["product_id"], name: "index_items_on_product_id"
  end

  create_table "orders", primary_key: "order_number", force: :cascade do |t|
    t.datetime "date"
    t.integer "status"
    t.decimal "total"
    t.bigint "waiter_id"
    t.bigint "table_id", null: false
    t.index ["table_id"], name: "index_orders_on_table_id"
    t.index ["waiter_id"], name: "index_orders_on_waiter_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.decimal "price", precision: 8, scale: 3
    t.integer "category"
    t.string "image"
  end

  create_table "tables", force: :cascade do |t|
    t.integer "status"
    t.integer "capacity"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role", default: 0, null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "events", "orders", column: "order_number", primary_key: "order_number"
  add_foreign_key "events", "users"
  add_foreign_key "invoices", "clients"
  add_foreign_key "invoices", "orders", column: "order_number", primary_key: "order_number"
  add_foreign_key "items", "orders", column: "order_number", primary_key: "order_number"
  add_foreign_key "items", "products"
  add_foreign_key "orders", "tables"
  add_foreign_key "orders", "users", column: "waiter_id", on_delete: :restrict
end
