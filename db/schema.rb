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

ActiveRecord::Schema.define(version: 2020_05_06_234309) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "admin_id", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ages", force: :cascade do |t|
    t.integer "F1910", null: false
    t.integer "F1920", null: false
    t.integer "F1930", null: false
    t.integer "F1940", null: false
    t.integer "F1950", null: false
    t.integer "F1960", null: false
    t.integer "F1970", null: false
    t.integer "F1980", null: false
    t.integer "F1990", null: false
    t.integer "F2000", null: false
    t.integer "F2010", null: false
    t.integer "M1910", null: false
    t.integer "M1920", null: false
    t.integer "M1930", null: false
    t.integer "M1940", null: false
    t.integer "M1950", null: false
    t.integer "M1960", null: false
    t.integer "M1970", null: false
    t.integer "M1980", null: false
    t.integer "M1990", null: false
    t.integer "M2000", null: false
    t.integer "M2010", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "careers", force: :cascade do |t|
    t.integer "talent_id", null: false
    t.integer "role", null: false
    t.date "date", null: false
    t.string "work", null: false
    t.boolean "is_pro", null: false
    t.string "detail"
    t.string "link1"
    t.string "link1_title"
    t.string "link2"
    t.string "link2_title"
    t.string "link3"
    t.string "link3_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "consts" because of following StandardError
#   Unknown type 'sring' for column 'value_str'

  create_table "event_ages", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "total", null: false
    t.integer "F1910", null: false
    t.integer "F1920", null: false
    t.integer "F1930", null: false
    t.integer "F1940", null: false
    t.integer "F1950", null: false
    t.integer "F1960", null: false
    t.integer "F1970", null: false
    t.integer "F1980", null: false
    t.integer "F1990", null: false
    t.integer "F2000", null: false
    t.integer "F2010", null: false
    t.integer "M1910", null: false
    t.integer "M1920", null: false
    t.integer "M1930", null: false
    t.integer "M1940", null: false
    t.integer "M1950", null: false
    t.integer "M1960", null: false
    t.integer "M1970", null: false
    t.integer "M1980", null: false
    t.integer "M1990", null: false
    t.integer "M2000", null: false
    t.integer "M2010", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_prefectures", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "total", null: false
    t.integer "Hokkaido", null: false
    t.integer "Aomori", null: false
    t.integer "Iwate", null: false
    t.integer "Miyagi", null: false
    t.integer "Akita", null: false
    t.integer "Yamagata", null: false
    t.integer "Fukushima", null: false
    t.integer "Ibaraki", null: false
    t.integer "Tochigi", null: false
    t.integer "Gunma", null: false
    t.integer "Saitama", null: false
    t.integer "Chiba", null: false
    t.integer "Tokyo", null: false
    t.integer "Kanagawa", null: false
    t.integer "Niigata", null: false
    t.integer "Toyama", null: false
    t.integer "Ishikawa", null: false
    t.integer "Fukui", null: false
    t.integer "Yamanashi", null: false
    t.integer "Nagano", null: false
    t.integer "Gifu", null: false
    t.integer "Shizuoka", null: false
    t.integer "Aichi", null: false
    t.integer "Mie", null: false
    t.integer "Shiga", null: false
    t.integer "Kyoto", null: false
    t.integer "Osaka", null: false
    t.integer "Hyogo", null: false
    t.integer "Nara", null: false
    t.integer "Wakayama", null: false
    t.integer "Tottori", null: false
    t.integer "Shimane", null: false
    t.integer "Okayama", null: false
    t.integer "Hiroshima", null: false
    t.integer "Yamaguchi", null: false
    t.integer "Tokushima", null: false
    t.integer "Kagawa", null: false
    t.integer "Ehime", null: false
    t.integer "Kochi", null: false
    t.integer "Fukuoka", null: false
    t.integer "Saga", null: false
    t.integer "Nagasaki", null: false
    t.integer "Kumamoto", null: false
    t.integer "Oita", null: false
    t.integer "Miyazaki", null: false
    t.integer "Kagoshima", null: false
    t.integer "Okinawa", null: false
    t.integer "Others", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer "event_type", null: false
    t.boolean "is_fake", null: false
    t.boolean "is_active", null: false
    t.date "date", null: false
    t.string "title", null: false
    t.text "detail"
    t.integer "population_change"
    t.string "half_sinking"
    t.string "sinking"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pollution"
    t.string "half_pollution"
    t.integer "member_id"
    t.boolean "delault_flg"
  end

  create_table "images", force: :cascade do |t|
    t.integer "talent_id"
    t.string "alt"
    t.string "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["talent_id"], name: "index_images_on_talent_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "name", null: false
    t.string "mail", null: false
    t.boolean "admin", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "unsbscribe_date"
  end

  create_table "opportunities", force: :cascade do |t|
    t.integer "producer_id_id", null: false
    t.string "roles", null: false
    t.string "title", null: false
    t.text "detail", null: false
    t.datetime "post_end_date", null: false
    t.date "start_date"
    t.date "end_date"
    t.string "date_remarks"
    t.integer "payment_type", null: false
    t.integer "payment", null: false
    t.string "payment_remarks"
    t.integer "sex", null: false
    t.string "sex_remarks"
    t.integer "age_low", null: false
    t.integer "age_high", null: false
    t.integer "experience", null: false
    t.text "talent_detail", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["producer_id_id"], name: "index_opportunities_on_producer_id_id"
  end

  create_table "prefectures", force: :cascade do |t|
    t.integer "Hokkaido", null: false
    t.integer "Aomori", null: false
    t.integer "Iwate", null: false
    t.integer "Miyagi", null: false
    t.integer "Akita", null: false
    t.integer "Yamagata", null: false
    t.integer "Fukushima", null: false
    t.integer "Ibaraki", null: false
    t.integer "Tochigi", null: false
    t.integer "Gunma", null: false
    t.integer "Saitama", null: false
    t.integer "Chiba", null: false
    t.integer "Tokyo", null: false
    t.integer "Kanagawa", null: false
    t.integer "Niigata", null: false
    t.integer "Toyama", null: false
    t.integer "Ishikawa", null: false
    t.integer "Fukui", null: false
    t.integer "Yamanashi", null: false
    t.integer "Nagano", null: false
    t.integer "Gifu", null: false
    t.integer "Shizuoka", null: false
    t.integer "Aichi", null: false
    t.integer "Mie", null: false
    t.integer "Shiga", null: false
    t.integer "Kyoto", null: false
    t.integer "Osaka", null: false
    t.integer "Hyogo", null: false
    t.integer "Nara", null: false
    t.integer "Wakayama", null: false
    t.integer "Tottori", null: false
    t.integer "Shimane", null: false
    t.integer "Okayama", null: false
    t.integer "Hiroshima", null: false
    t.integer "Yamaguchi", null: false
    t.integer "Tokushima", null: false
    t.integer "Kagawa", null: false
    t.integer "Ehime", null: false
    t.integer "Kochi", null: false
    t.integer "Fukuoka", null: false
    t.integer "Saga", null: false
    t.integer "Nagasaki", null: false
    t.integer "Kumamoto", null: false
    t.integer "Oita", null: false
    t.integer "Miyazaki", null: false
    t.integer "Kagoshima", null: false
    t.integer "Okinawa", null: false
    t.integer "Others", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "producers", force: :cascade do |t|
    t.string "org_id", null: false
    t.string "name", null: false
    t.string "name_yomi", null: false
    t.string "homepage", null: false
    t.string "mail_address", null: false
    t.string "phone_number", null: false
    t.integer "postal_code", null: false
    t.string "residence", null: false
    t.string "business", null: false
    t.text "detail", null: false
    t.string "staff_name", null: false
    t.string "staff_name_yomi", null: false
    t.string "staff_roll", null: false
    t.boolean "is_use_staff_mail_address", null: false
    t.string "staff_mail_address"
    t.boolean "is_use_staff_phone_number", null: false
    t.string "staff_phone_number"
    t.date "unsubscribe_bate"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "socials", force: :cascade do |t|
    t.integer "member_type"
    t.integer "member_id"
    t.string "twitter"
    t.string "facebook"
    t.string "instagram"
    t.string "mixi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "talents", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_yomi", null: false
    t.string "talent_name"
    t.string "talent_name_yomi"
    t.boolean "is_use_talent_name", null: false
    t.integer "sex", null: false
    t.string "sex_remarks"
    t.date "birth_date", null: false
    t.integer "residence", null: false
    t.string "residence_remarks"
    t.string "roles", null: false
    t.text "detail", null: false
    t.string "mail_address", null: false
    t.string "phone_number", null: false
    t.date "unsubscribe_bate"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
