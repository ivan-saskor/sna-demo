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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110720215604) do

  create_table "messages", :force => true do |t|
    t.string   "text"
    t.integer  "from_id"
    t.integer  "to_id"
    t.datetime "sent_on"
    t.datetime "read_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "nick"
    t.string   "mood"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password"
  end

  create_table "person_relations", :force => true do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.string   "relation_status_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
