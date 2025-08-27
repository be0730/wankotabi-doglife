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

ActiveRecord::Schema[8.0].define(version: 2025_08_27_084247) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "facilities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.integer "category", default: 0, null: false
    t.text "overview"
    t.string "full_address"
    t.string "postal_code"
    t.string "prefecture_code"
    t.string "prefecture_name"
    t.string "city"
    t.string "street"
    t.string "building"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "phone_number"
    t.string "business_hours"
    t.string "closed_day"
    t.string "homepage_url"
    t.string "instagram_url"
    t.string "facebook_url"
    t.string "x_url"
    t.string "supplement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_facilities_on_category"
    t.index ["latitude", "longitude"], name: "index_facilities_on_latitude_and_longitude"
    t.index ["prefecture_code"], name: "index_facilities_on_prefecture_code"
    t.index ["user_id"], name: "index_facilities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "facilities", "users"
end
