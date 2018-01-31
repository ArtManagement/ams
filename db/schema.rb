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

ActiveRecord::Schema.define(version: 20180131162720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artist_classes", force: :cascade do |t|
    t.string  "artist_class"
    t.string  "artist_class_eng"
    t.integer "sort"
    t.boolean "usable"
  end

  create_table "artists", force: :cascade do |t|
    t.integer  "artist_class_id"
    t.string   "name"
    t.string   "kana"
    t.string   "name_eng"
    t.datetime "birth_date"
    t.datetime "death_date"
    t.string   "real_name"
    t.string   "real_name_eng"
    t.string   "birth_place"
    t.string   "birth_place_eng"
    t.integer  "nationality_id"
    t.string   "affiliation"
    t.string   "affiliation_eng"
    t.text     "brief_history"
    t.text     "brief_history_eng"
    t.text     "note"
    t.text     "note_eng"
  end

  create_table "artworks", force: :cascade do |t|
    t.string   "artwork_no"
    t.integer  "artist_id"
    t.string   "title"
    t.string   "title_eng"
    t.integer  "category_id"
    t.integer  "technique_id"
    t.string   "technique_etc"
    t.string   "technique_eng"
    t.string   "material"
    t.string   "material_eng"
    t.integer  "size_id"
    t.integer  "size_unit_id"
    t.string   "size_etc"
    t.string   "edition"
    t.integer  "edition_no"
    t.integer  "edition_limit"
    t.string   "production_year"
    t.string   "raisonne"
    t.integer  "motif_id"
    t.integer  "format_id"
    t.float    "height"
    t.float    "width"
    t.float    "depth"
    t.float    "frame_height"
    t.float    "frame_width"
    t.float    "frame_depth"
    t.string   "unit"
    t.string   "frame_unit"
    t.boolean  "sign"
    t.boolean  "signature"
    t.boolean  "seal"
    t.boolean  "co_seal"
    t.boolean  "co_box"
    t.boolean  "certificate"
    t.boolean  "cloth_box"
    t.boolean  "insert_box"
    t.boolean  "cover_box"
    t.boolean  "yellow_bag"
    t.integer  "retail_price"
    t.integer  "wholesale_price"
    t.integer  "reference_price"
    t.text     "condition"
    t.text     "note"
    t.string   "image1"
    t.string   "image2"
    t.string   "image3"
    t.string   "image4"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string  "category"
    t.string  "category_eng"
    t.integer "sort"
    t.boolean "usable"
  end

  create_table "companies", force: :cascade do |t|
    t.string  "company"
    t.string  "company_eng"
    t.string  "position"
    t.string  "position_eng"
    t.string  "president"
    t.string  "president_eng"
    t.string  "zip_code"
    t.integer "prefecture_id"
    t.string  "address1"
    t.string  "address2"
    t.string  "address1_eng"
    t.string  "address2_eng"
    t.string  "tel"
    t.string  "fax"
    t.string  "email"
    t.string  "url"
    t.integer "tax_class_id"
    t.float   "tax_rate"
    t.integer "account_closing_month"
    t.boolean "usable"
  end

  create_table "consign_return_slips", force: :cascade do |t|
    t.string   "slip_no"
    t.datetime "date"
    t.integer  "customer_id"
    t.integer  "staff_id"
    t.text     "note"
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "sort1"
    t.string   "sort2"
    t.string   "sort3"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "consign_returns", force: :cascade do |t|
    t.integer  "consign_return_slip_id"
    t.integer  "consign_id"
    t.text     "note"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "consign_slips", force: :cascade do |t|
    t.string   "slip_no"
    t.datetime "date"
    t.integer  "customer_id"
    t.datetime "scheduled_date"
    t.integer  "tax_class_id"
    t.float    "tax_rate"
    t.integer  "staff_id"
    t.text     "note"
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "sort1"
    t.string   "sort2"
    t.string   "sort3"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "consigns", force: :cascade do |t|
    t.integer  "consign_slip_id"
    t.integer  "artwork_id"
    t.integer  "price"
    t.text     "note"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "counters", force: :cascade do |t|
    t.integer "company_id"
    t.integer "year"
    t.integer "artwork"
    t.integer "purchase"
    t.integer "sale"
    t.integer "trust"
    t.integer "consign"
    t.integer "payment"
    t.integer "deposit"
    t.integer "frame"
    t.integer "exhibit"
  end

  create_table "customer_classes", force: :cascade do |t|
    t.string  "customer_class"
    t.string  "customer_class_eng"
    t.integer "sort"
    t.boolean "usable"
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "customer_no"
    t.integer  "customer_class_id"
    t.string   "name"
    t.string   "kana"
    t.string   "abbreviation"
    t.string   "prefix"
    t.string   "zip_code"
    t.integer  "prefecture_id"
    t.string   "address1"
    t.string   "address2"
    t.string   "tel"
    t.string   "fax"
    t.string   "mobile"
    t.string   "email"
    t.string   "url"
    t.string   "rank"
    t.boolean  "a"
    t.boolean  "b"
    t.boolean  "c"
    t.boolean  "d"
    t.boolean  "e"
    t.boolean  "f"
    t.boolean  "g"
    t.boolean  "h"
    t.string   "note"
    t.integer  "company_id"
    t.boolean  "usable"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "exhibit_slips", force: :cascade do |t|
    t.string   "slip_no"
    t.datetime "date"
    t.integer  "customer_id"
    t.datetime "scheduled_date"
    t.string   "event"
    t.integer  "tax_class_id"
    t.float    "tax_rate"
    t.integer  "staff_id"
    t.text     "note"
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "sort1"
    t.string   "sort2"
    t.string   "sort3"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "exhibits", force: :cascade do |t|
    t.integer  "exhibit_slip_id"
    t.integer  "artwork_id"
    t.integer  "price"
    t.text     "note"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "formats", force: :cascade do |t|
    t.string  "format"
    t.string  "format_eng"
    t.integer "sort"
    t.boolean "usable"
  end

  create_table "images", force: :cascade do |t|
    t.integer  "artist_id"
    t.string   "title"
    t.integer  "category_id"
    t.integer  "technique_id"
    t.string   "technique_etc"
    t.integer  "size_id"
    t.integer  "size_unit_id"
    t.string   "size_etc"
    t.string   "image1"
    t.string   "image2"
    t.string   "image3"
    t.string   "image4"
    t.string   "image5"
    t.string   "image6"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "motifs", force: :cascade do |t|
    t.string  "motif"
    t.string  "motif_eng"
    t.integer "sort"
    t.boolean "usable"
  end

  create_table "nationalities", force: :cascade do |t|
    t.string  "nationality"
    t.string  "nationality_eng"
    t.integer "sort"
    t.boolean "usable"
  end

  create_table "payment_slips", force: :cascade do |t|
    t.string   "slip_no"
    t.datetime "date"
    t.integer  "customer_id"
    t.integer  "staff_id"
    t.text     "note"
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "sort1"
    t.string   "sort2"
    t.string   "sort3"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "payment_slip_id"
    t.integer  "purchase_id"
    t.integer  "amount"
    t.text     "note"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "prefectures", force: :cascade do |t|
    t.string  "prefecture"
    t.string  "prefecture_eng"
    t.integer "sort"
    t.boolean "usable"
  end

  create_table "purchase_cancel_slips", force: :cascade do |t|
    t.string   "slip_no"
    t.datetime "date"
    t.integer  "customer_id"
    t.integer  "staff_id"
    t.text     "note"
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "sort1"
    t.string   "sort2"
    t.string   "sort3"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "purchase_cancels", force: :cascade do |t|
    t.integer  "purchase_cancel_slip_id"
    t.integer  "purchase_id"
    t.text     "note"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "purchase_slips", force: :cascade do |t|
    t.string   "slip_no"
    t.datetime "date"
    t.integer  "slip_class_id"
    t.integer  "customer_id"
    t.datetime "scheduled_date"
    t.integer  "tax_class_id"
    t.float    "tax_rate"
    t.integer  "staff_id"
    t.text     "note"
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "sort1"
    t.string   "sort2"
    t.string   "sort3"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "purchase_slip_id"
    t.integer  "artwork_id"
    t.integer  "price"
    t.text     "note"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "receipt_slips", force: :cascade do |t|
    t.string   "slip_no"
    t.datetime "date"
    t.integer  "customer_id"
    t.integer  "staff_id"
    t.text     "note"
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "sort1"
    t.string   "sort2"
    t.string   "sort3"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "receipts", force: :cascade do |t|
    t.integer  "receipt_slip_id"
    t.integer  "sale_id"
    t.integer  "amount"
    t.text     "note"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "sale_cancel_slips", force: :cascade do |t|
    t.string   "slip_no"
    t.datetime "date"
    t.integer  "customer_id"
    t.integer  "staff_id"
    t.text     "note"
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "sort1"
    t.string   "sort2"
    t.string   "sort3"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sale_cancels", force: :cascade do |t|
    t.integer  "sale_cancel_slip_id"
    t.integer  "sale_id"
    t.text     "note"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "sale_slips", force: :cascade do |t|
    t.string   "slip_no"
    t.datetime "date"
    t.integer  "customer_id"
    t.datetime "scheduled_date"
    t.integer  "tax_class_id"
    t.float    "tax_rate"
    t.integer  "staff_id"
    t.text     "note"
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "sort1"
    t.string   "sort2"
    t.string   "sort3"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "sales", force: :cascade do |t|
    t.integer  "sale_slip_id"
    t.integer  "artwork_id"
    t.integer  "price"
    t.text     "note"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "size_units", force: :cascade do |t|
    t.string "size_unit"
    t.string "size_unit_eng"
  end

  create_table "sizes", force: :cascade do |t|
    t.string "size"
    t.string "size_eng"
  end

  create_table "sorts", force: :cascade do |t|
    t.string "sort_key"
    t.string "sort"
  end

  create_table "staffs", force: :cascade do |t|
    t.string  "staff_no"
    t.string  "staff"
    t.integer "company_id"
    t.integer "sort"
    t.boolean "usable"
  end

  create_table "styles", force: :cascade do |t|
    t.string "style"
    t.string "style_eng"
  end

  create_table "techniques", force: :cascade do |t|
    t.integer "category_id"
    t.string  "technique"
    t.string  "technique_eng"
    t.integer "sort"
    t.boolean "usable"
  end

  create_table "trust_return_slips", force: :cascade do |t|
    t.string   "slip_no"
    t.datetime "date"
    t.integer  "customer_id"
    t.integer  "staff_id"
    t.text     "note"
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "sort1"
    t.string   "sort2"
    t.string   "sort3"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "trust_returns", force: :cascade do |t|
    t.integer  "trust_return_slip_id"
    t.integer  "trust_id"
    t.text     "note"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "trust_slips", force: :cascade do |t|
    t.string   "slip_no"
    t.datetime "date"
    t.integer  "customer_id"
    t.datetime "scheduled_date"
    t.integer  "tax_class_id"
    t.float    "tax_rate"
    t.integer  "staff_id"
    t.text     "note"
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "sort1"
    t.string   "sort2"
    t.string   "sort3"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "trusts", force: :cascade do |t|
    t.integer  "trust_slip_id"
    t.integer  "artwork_id"
    t.integer  "price"
    t.text     "note"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "company_id"
    t.integer "staff_id"
    t.string  "password_digest"
  end

end
