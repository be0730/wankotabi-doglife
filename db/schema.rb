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

ActiveRecord::Schema[8.0].define(version: 2025_11_06_020607) do
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

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id", null: false
    t.bigint "facility_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_id", "created_at"], name: "index_comments_on_facility_id_and_created_at"
    t.index ["facility_id"], name: "index_comments_on_facility_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

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
    t.bigint "prefecture_id", null: false
    t.index ["category"], name: "index_facilities_on_category"
    t.index ["latitude", "longitude"], name: "index_facilities_on_latitude_and_longitude"
    t.index ["prefecture_code"], name: "index_facilities_on_prefecture_code"
    t.index ["prefecture_id"], name: "index_facilities_on_prefecture_id"
    t.index ["user_id"], name: "index_facilities_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "facility_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_id"], name: "index_favorites_on_facility_id"
    t.index ["user_id", "facility_id"], name: "index_favorites_on_user_id_and_facility_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "prefectures", force: :cascade do |t|
    t.string "name"
    t.integer "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "key", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_tags_on_key", unique: true
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
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "facilities"
  add_foreign_key "comments", "users"
  add_foreign_key "facilities", "prefectures"
  add_foreign_key "facilities", "users"
  add_foreign_key "favorites", "facilities"
  add_foreign_key "favorites", "users"
end
