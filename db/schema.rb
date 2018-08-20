# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170104102558) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "bank_slip_statuses", force: :cascade do |t|
    t.integer "sequence_sts"
    t.string  "name"
  end

  create_table "bank_slips", force: :cascade do |t|
    t.string   "vat_number"
    t.string   "bank_code"
    t.date     "issued_date"
    t.date     "due_date"
    t.date     "paid_date"
    t.date     "canceled_date"
    t.float    "total_cost"
    t.string   "details"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "revenue_id"
    t.date     "generated_date"
    t.integer  "bank_slip_status_id"
    t.index ["bank_slip_status_id"], name: "index_bank_slips_on_bank_slip_status_id", using: :btree
    t.index ["revenue_id"], name: "index_bank_slips_on_revenue_id", using: :btree
  end

  create_table "bank_slips_channel_stores", id: false, force: :cascade do |t|
    t.integer "channel_store_id", null: false
    t.integer "bank_slip_id",     null: false
    t.index ["bank_slip_id", "channel_store_id"], name: "bank_slip_channel_index", using: :btree
    t.index ["channel_store_id", "bank_slip_id"], name: "channel_bank_slip_index", using: :btree
  end

  create_table "channel_stores", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "client_id"
    t.integer  "cnpj_id"
    t.integer  "store_id"
    t.integer  "marketplace_id"
    t.float    "monthly_payment"
    t.float    "order_payment"
    t.integer  "payday"
    t.integer  "additional_time_day"
    t.string   "additional_time_day_based"
    t.integer  "table_tax_id"
    t.string   "status"
    t.index ["client_id"], name: "index_channel_stores_on_client_id", using: :btree
    t.index ["cnpj_id"], name: "index_channel_stores_on_cnpj_id", using: :btree
    t.index ["marketplace_id"], name: "index_channel_stores_on_marketplace_id", using: :btree
    t.index ["store_id"], name: "index_channel_stores_on_store_id", using: :btree
    t.index ["table_tax_id"], name: "index_channel_stores_on_table_tax_id", using: :btree
  end

  create_table "client_contacts", force: :cascade do |t|
    t.string  "name"
    t.string  "email"
    t.string  "phone"
    t.integer "client_id"
    t.index ["client_id"], name: "index_client_contacts_on_client_id", using: :btree
  end

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "cnpj_id"
    t.string   "status",                    null: false
    t.integer  "payday"
    t.integer  "additional_time_day"
    t.string   "additional_time_day_based"
    t.index ["cnpj_id"], name: "index_clients_on_cnpj_id", using: :btree
  end

  create_table "cnpjs", force: :cascade do |t|
    t.string   "vat_number"
    t.string   "company_name"
    t.string   "trading_name"
    t.string   "street_address"
    t.string   "neighborhood_address"
    t.string   "city_address"
    t.string   "uf_address"
    t.string   "detail_address"
    t.string   "cep_address"
    t.string   "email"
    t.string   "phone"
    t.string   "situation"
    t.date     "situation_date"
    t.string   "type"
    t.string   "legal_nature"
    t.date     "opening_date"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "number_address"
  end

  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cnpj_id"
    t.index ["cnpj_id"], name: "index_companies_on_cnpj_id", using: :btree
  end

  create_table "marketplaces", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "revenues", force: :cascade do |t|
    t.string   "month"
    t.string   "year"
    t.boolean  "manually"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "bank_slip_id"
    t.integer  "client_id"
    t.index ["bank_slip_id"], name: "index_revenues_on_bank_slip_id", using: :btree
    t.index ["client_id"], name: "index_revenues_on_client_id", using: :btree
  end

  create_table "stores", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "client_id"
    t.string   "status"
    t.index ["client_id"], name: "index_stores_on_client_id", using: :btree
  end

  create_table "table_tax_rows", force: :cascade do |t|
    t.string   "row_type"
    t.string   "row_measurement"
    t.float    "row_value"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "row_name"
  end

  create_table "table_taxes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "client_id"
    t.integer  "row_ids",      default: [],              array: true
    t.string   "table_scope"
    t.string   "status"
    t.integer  "tax_rule_ids", default: [],              array: true
    t.index ["client_id"], name: "index_table_taxes_on_client_id", using: :btree
  end

  create_table "tax_rules", force: :cascade do |t|
    t.integer  "row_ids",      default: [],              array: true
    t.string   "operator"
    t.string   "measurement"
    t.float    "value"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "table_tax_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "sector",                              null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "bank_slips", "bank_slip_statuses"
  add_foreign_key "bank_slips", "revenues"
  add_foreign_key "channel_stores", "clients"
  add_foreign_key "channel_stores", "cnpjs"
  add_foreign_key "channel_stores", "marketplaces"
  add_foreign_key "channel_stores", "stores"
  add_foreign_key "channel_stores", "table_taxes"
  add_foreign_key "client_contacts", "clients"
  add_foreign_key "clients", "cnpjs"
  add_foreign_key "companies", "cnpjs"
  add_foreign_key "revenues", "clients"
  add_foreign_key "stores", "clients"
  add_foreign_key "table_taxes", "clients"
  add_foreign_key "tax_rules", "table_taxes"
end
