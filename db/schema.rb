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

ActiveRecord::Schema[7.2].define(version: 2024_11_18_202054) do
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

  create_table "dishes", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.integer "calories"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.datetime "deleted_at"
    t.index ["restaurant_id"], name: "index_dishes_on_restaurant_id"
  end

  create_table "dishes_tags", force: :cascade do |t|
    t.integer "dish_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_dishes_tags_on_dish_id"
    t.index ["tag_id"], name: "index_dishes_tags_on_tag_id"
  end

  create_table "drinks", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.boolean "alcoholic", default: false, null: false
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.datetime "deleted_at"
    t.index ["restaurant_id"], name: "index_drinks_on_restaurant_id"
  end

  create_table "menu_dishes", force: :cascade do |t|
    t.integer "menu_id", null: false
    t.integer "dish_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_menu_dishes_on_dish_id"
    t.index ["menu_id"], name: "index_menu_dishes_on_menu_id"
  end

  create_table "menu_drinks", force: :cascade do |t|
    t.integer "menu_id", null: false
    t.integer "drink_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drink_id"], name: "index_menu_drinks_on_drink_id"
    t.index ["menu_id"], name: "index_menu_drinks_on_menu_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name", null: false
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id", "name"], name: "index_menus_on_restaurant_id_and_name", unique: true
    t.index ["restaurant_id"], name: "index_menus_on_restaurant_id"
  end

  create_table "opentimes", force: :cascade do |t|
    t.integer "week_day", null: false
    t.time "open", null: false
    t.time "close", null: false
    t.boolean "closed", default: false
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_opentimes_on_restaurant_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "portion_id", null: false
    t.integer "dish_id"
    t.integer "drink_id"
    t.string "note"
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_order_items_on_dish_id"
    t.index ["drink_id"], name: "index_order_items_on_drink_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["portion_id"], name: "index_order_items_on_portion_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "customer_name", null: false
    t.string "customer_cpf"
    t.string "customer_email"
    t.string "customer_phone"
    t.integer "restaurant_id", null: false
    t.string "code", null: false
    t.integer "status", default: 0, null: false
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cancellation_reason"
    t.index ["restaurant_id"], name: "index_orders_on_restaurant_id"
  end

  create_table "portion_price_histories", force: :cascade do |t|
    t.decimal "price", null: false
    t.integer "portion_id", null: false
    t.datetime "changed_at", null: false
    t.index ["portion_id"], name: "index_portion_price_histories_on_portion_id"
  end

  create_table "portions", force: :cascade do |t|
    t.string "description", null: false
    t.decimal "price", null: false
    t.string "portionable_type", null: false
    t.integer "portionable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portionable_type", "portionable_id"], name: "index_portions_on_portionable"
  end

  create_table "pre_registered_users", force: :cascade do |t|
    t.string "email", null: false
    t.string "cpf", null: false
    t.integer "restaurant_id", null: false
    t.boolean "used", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_pre_registered_users_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "trade_name", null: false
    t.string "legal_name", null: false
    t.string "cnpj", null: false
    t.string "address", null: false
    t.string "phone", null: false
    t.string "email", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cnpj"], name: "index_restaurants_on_cnpj", unique: true
    t.index ["code"], name: "index_restaurants_on_code", unique: true
    t.index ["email"], name: "index_restaurants_on_email", unique: true
    t.index ["legal_name"], name: "index_restaurants_on_legal_name", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_tags_on_restaurant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "cpf", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.integer "restaurant_id"
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "dishes", "restaurants"
  add_foreign_key "dishes_tags", "dishes"
  add_foreign_key "dishes_tags", "tags"
  add_foreign_key "drinks", "restaurants"
  add_foreign_key "menu_dishes", "dishes"
  add_foreign_key "menu_dishes", "menus"
  add_foreign_key "menu_drinks", "drinks"
  add_foreign_key "menu_drinks", "menus"
  add_foreign_key "menus", "restaurants"
  add_foreign_key "opentimes", "restaurants"
  add_foreign_key "order_items", "dishes"
  add_foreign_key "order_items", "drinks"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "portions"
  add_foreign_key "orders", "restaurants"
  add_foreign_key "portion_price_histories", "portions"
  add_foreign_key "pre_registered_users", "restaurants"
  add_foreign_key "tags", "restaurants"
end
