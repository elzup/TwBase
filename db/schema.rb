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

ActiveRecord::Schema.define(version: 20151229080603) do

  create_table "tweets", force: :cascade do |t|
    t.string   "tweet_id"
    t.string   "text"
    t.integer  "user_id"
    t.float    "lat"
    t.float    "long"
    t.boolean  "for_sq"
    t.string   "text_keyword"
    t.string   "search_word"
    t.datetime "tweeted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "tweets", ["created_at"], name: "index_tweets_on_created_at"
  add_index "tweets", ["tweeted_at"], name: "index_tweets_on_tweeted_at"
  add_index "tweets", ["user_id"], name: "index_tweets_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "tid"
    t.string   "screen_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
