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

ActiveRecord::Schema.define(version: 20140318065447) do

  create_table "recipes", force: true do |t|
    t.string   "title"
    t.string   "book"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_contents", force: true do |t|
    t.integer  "recipe_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_contents", ["recipe_id"], name: "index_search_contents_on_recipe_id", using: :btree
  add_index "search_contents", ["title", "content"], name: "search_contents_fulltext_index", type: :fulltext

end
