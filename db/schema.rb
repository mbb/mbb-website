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

ActiveRecord::Schema.define(:version => 20100523064036) do

  create_table "attached_files", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "news_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "concerts", :force => true do |t|
    t.string "title"
    t.date   "date"
    t.string "location"
    t.text   "description"
    t.time   "time"
    t.string "google_map_embed_url"
    t.string "google_map_link_url"
  end

  create_table "fans", :force => true do |t|
    t.string   "email",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.text     "biography"
    t.integer  "section_id"
    t.datetime "created_at"
    t.string   "name"
    t.string   "email",                     :limit => 100, :default => "",    :null => false
    t.string   "crypted_password",          :limit => 128, :default => "",    :null => false
    t.string   "salt",                      :limit => 128, :default => "",    :null => false
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.boolean  "password_is_temporary",                    :default => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.integer  "position"
    t.boolean  "visible",                                  :default => true
    t.string   "phone_number"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.integer  "failed_login_count",                       :default => 0,     :null => false
    t.datetime "last_login_at"
    t.boolean  "privileged",                               :default => false
  end

  add_index "members", ["email"], :name => "index_members_on_email", :unique => true

  create_table "news_items", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "is_private", :default => true, :null => false
    t.datetime "created_at"
  end

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.boolean  "visible",    :default => true
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

end
