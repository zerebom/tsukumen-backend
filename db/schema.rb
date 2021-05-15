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

ActiveRecord::Schema.define(version: 2021_05_15_024655) do

  create_table "addresses", force: :cascade do |t|
    t.integer "shop_id"
    t.float "latitude"
    t.float "longitude"
    t.string "postalcode"
    t.string "prefecture"
    t.string "county"
    t.string "locality"
    t.string "thoroughfare"
    t.string "sub_thoroughfare"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lat_lons", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_lat_lons_on_latitude_and_longitude", unique: true
  end

  create_table "photos", force: :cascade do |t|
    t.integer "shop_id"
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string "reviewer"
    t.integer "star"
    t.text "review_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "place_id"
    t.string "opening_hours"
    t.integer "lat_lon_id"
  end

end
