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

ActiveRecord::Schema.define(:version => 20090519000000) do

  create_table "members", :force => true do |t|
    t.text     "biography"
    t.integer  "section_id"
    t.datetime "created_at"
    t.string   "name"
    t.string   "email",                     :limit => 100, :default => "",    :null => false
    t.string   "crypted_password",          :limit => 100
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.boolean  "password_is_temporary",                    :default => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

  add_index "members", ["email"], :name => "index_members_on_email", :unique => true

  create_table "members_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "member_id"
  end

  add_index "members_roles", ["member_id"], :name => "index_members_roles_on_member_id"
  add_index "members_roles", ["role_id"], :name => "index_members_roles_on_role_id"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "sections", :force => true do |t|
    t.string   "instrument"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

end
