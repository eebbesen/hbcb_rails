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

ActiveRecord::Schema.define(version: 20160131221437) do

  create_table "bios", force: :cascade do |t|
    t.text     "name"
    t.text     "parish"
    t.text     "entered_service"
    t.text     "dates"
    t.text     "filename"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "place_of_birth"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "notes"
  end

  create_table "postings", force: :cascade do |t|
    t.integer  "bio_id"
    t.text     "years"
    t.text     "position"
    t.text     "post"
    t.text     "district"
    t.text     "hbca_reference"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "ship"
  end

  add_index "postings", ["bio_id"], name: "index_postings_on_bio_id"

end
