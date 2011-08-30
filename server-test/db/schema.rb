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

ActiveRecord::Schema.define(:version => 20110728215708) do

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
    t.string   "visibility_status"
    t.string   "gravatar_code"
    t.date     "born_on"
    t.string   "gender"
    t.boolean  "looking_for_genders_male"
    t.boolean  "looking_for_genders_female"
    t.boolean  "looking_for_genders_other"
    t.string   "description"
    t.string   "occupation"
    t.string   "hobby"
    t.string   "main_location"
    t.decimal  "last_known_location_latitude"
    t.decimal  "last_known_location_longitude"
    t.datetime "last_activity_on"
  end

  create_table "person_relations", :force => true do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.string   "relation_status_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "rejected_on"
  end

end
