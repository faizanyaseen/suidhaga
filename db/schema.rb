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

ActiveRecord::Schema[8.0].define(version: 2025_09_01_120657) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name"
    t.string "phone", null: false
    t.string "email"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shop_id"
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["phone"], name: "index_customers_on_phone", unique: true
    t.index ["shop_id"], name: "index_customers_on_shop_id"
  end

  create_table "customers_measurement_types", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "measurement_type_id", null: false
    t.decimal "value", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "measurement_type_id"], name: "index_customers_measurements_unique", unique: true
    t.index ["customer_id"], name: "index_customers_measurement_types_on_customer_id"
    t.index ["measurement_type_id"], name: "index_customers_measurement_types_on_measurement_type_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "number_of_pieces", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "description"
    t.integer "status", default: 0
    t.index ["order_id"], name: "index_line_items_on_order_id"
  end

  create_table "line_items_measurement_types", force: :cascade do |t|
    t.bigint "line_item_id", null: false
    t.bigint "measurement_type_id", null: false
    t.float "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_item_id", "measurement_type_id"], name: "index_line_items_measurement_types"
    t.index ["line_item_id"], name: "index_line_items_measurement_types_on_line_item_id"
    t.index ["measurement_type_id"], name: "index_line_items_measurement_types_on_measurement_type_id"
  end

  create_table "measurement_types", force: :cascade do |t|
    t.string "key_en", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shop_id"
    t.string "key_ur"
    t.index ["shop_id", "key_en"], name: "index_measurement_types_on_shop_id_and_key_en", unique: true
    t.index ["shop_id", "key_ur"], name: "index_measurement_types_on_shop_id_and_key_ur", unique: true
    t.index ["shop_id"], name: "index_measurement_types_on_shop_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "order_number", null: false
    t.decimal "total_price", precision: 10, scale: 2
    t.integer "status", default: 0
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "delivery_date"
    t.datetime "delivered_at"
    t.bigint "tailor_id"
    t.boolean "active", default: true, null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["order_number"], name: "index_orders_on_order_number", unique: true
    t.index ["tailor_id"], name: "index_orders_on_tailor_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tailor_limit", default: 0, null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "plan_type", default: "free", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.integer "status", default: 0
    t.integer "max_customers", default: 10
    t.integer "max_orders", default: 50
    t.text "features", default: "[]"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_date"], name: "index_subscriptions_on_end_date"
    t.index ["user_id", "status"], name: "index_subscriptions_on_user_id_and_status"
    t.index ["user_id"], name: "index_subscriptions_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role", default: 0
    t.string "username"
    t.string "phone"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["shop_id"], name: "index_users_on_shop_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "customers", "shops"
  add_foreign_key "customers_measurement_types", "customers"
  add_foreign_key "customers_measurement_types", "measurement_types"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items_measurement_types", "line_items"
  add_foreign_key "line_items_measurement_types", "measurement_types"
  add_foreign_key "measurement_types", "shops"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "users", column: "tailor_id"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "users", "shops"
end
