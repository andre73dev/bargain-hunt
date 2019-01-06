# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20190101142422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "genres", force: :cascade do |t|
    t.string   "genres_id"
    t.string   "genres_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "asin"
    t.string   "title"
    t.string   "small_image"
    t.string   "medium_image"
    t.string   "large_image"
    t.decimal  "ofr_amount"
    t.decimal  "val_amount"
    t.integer  "sales_rank"
    t.string   "condition"
    t.string   "availability"
    t.string   "detail_page_url"
    t.datetime "release_date"
    t.string   "all_offers_url"
    t.string   "search_index"
    t.string   "browse_node"
    t.string   "browse_nodename"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "latest_items", force: :cascade do |t|
    t.string   "asin"
    t.string   "title"
    t.string   "small_image"
    t.string   "medium_image"
    t.string   "large_image"
    t.decimal  "ofr_amount"
    t.decimal  "val_amount"
    t.integer  "sales_rank"
    t.string   "condition"
    t.string   "availability"
    t.string   "detail_page_url"
    t.datetime "release_date"
    t.string   "all_offers_url"
    t.string   "search_index"
    t.string   "browse_node"
    t.string   "browse_nodename"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "rakuten_items", force: :cascade do |t|
    t.string   "item_code"
    t.string   "item_name"
    t.string   "small_image1"
    t.string   "small_image2"
    t.string   "small_image3"
    t.string   "medium_image1"
    t.string   "medium_image2"
    t.string   "medium_image3"
    t.decimal  "item_price"
    t.integer  "rank"
    t.string   "item_caption"
    t.string   "item_url"
    t.string   "genre_root_id"
    t.string   "genre_root_name"
    t.string   "genre_id"
    t.string   "genre_name"
    t.string   "shop_code"
    t.string   "shop_name"
    t.string   "shop_url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "rakuten_latest_items", force: :cascade do |t|
    t.string   "item_code"
    t.string   "item_name"
    t.string   "small_image1"
    t.string   "small_image2"
    t.string   "small_image3"
    t.string   "medium_image1"
    t.string   "medium_image2"
    t.string   "medium_image3"
    t.decimal  "item_price"
    t.integer  "rank"
    t.string   "item_caption"
    t.string   "item_url"
    t.string   "genre_root_id"
    t.string   "genre_root_name"
    t.string   "genre_id"
    t.string   "genre_name"
    t.string   "shop_code"
    t.string   "shop_name"
    t.string   "shop_url"
    t.integer  "rank_past"
    t.decimal  "item_price_past"
    t.datetime "item_update_past"
    t.decimal  "down_rate"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
