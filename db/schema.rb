# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100504200130) do

  create_table "chats", :force => true do |t|
    t.string   "login"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "post_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "episodes", :force => true do |t|
    t.string   "name"
    t.string   "safe_name"
    t.integer  "episode_number"
    t.integer  "season"
    t.integer  "serie"
    t.text     "tags"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plannings", :force => true do |t|
    t.string   "video"
    t.datetime "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", :force => true do |t|
    t.string   "name"
    t.string   "safe_name"
    t.text     "tags"
    t.integer  "nb_seasons"
    t.integer  "average_episode_duration"
    t.text     "desc"
    t.string   "genre"
    t.boolean  "is_film"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
