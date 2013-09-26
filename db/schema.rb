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

ActiveRecord::Schema.define(version: 20130926162042) do

  create_table "app_content_sets", force: true do |t|
    t.string   "issue"
    t.string   "learn_text"
    t.string   "call_text"
    t.string   "call_instruction"
    t.string   "app_phone_number"
    t.string   "listen_text"
    t.string   "message_from"
    t.string   "message_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header_color"
    t.string   "short_title"
    t.string   "call_in_code_digits", limit: 1
    t.string   "feedback_form_url"
  end

  create_table "feedback_inputs", force: true do |t|
    t.integer  "question_id"
    t.integer  "subject_id"
    t.integer  "neighborhood_id"
    t.integer  "property_id"
    t.string   "voice_file_url"
    t.integer  "numerical_response"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "call_source"
  end

  create_table "notification_subscriptions", force: true do |t|
    t.string   "email"
    t.boolean  "confirmed"
    t.datetime "confirmation_sent_at"
    t.string   "auth_token"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_email_sent_at"
  end

  create_table "property_info_sets", force: true do |t|
    t.integer  "property_id"
    t.integer  "condition_code",          limit: 1
    t.string   "condition"
    t.string   "estimated_cost_exterior"
    t.string   "estimated_cost_interior"
    t.string   "demo_order"
    t.string   "recommendation"
    t.string   "outcome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lat"
    t.string   "long"
  end

  create_table "questions", force: true do |t|
    t.text     "voice_text"
    t.string   "short_name"
    t.string   "feedback_type"
    t.string   "question_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "voice_file_id"
  end

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories"

  create_table "subjects", force: true do |t|
    t.string   "name"
    t.integer  "neighborhood_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "property_code"
    t.string   "parcel_id"
    t.string   "lat"
    t.string   "long"
    t.text     "description"
    t.datetime "most_recent_activity"
  end

  create_table "users", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "voice_files", force: true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name"
  end

  create_table "voice_transcriptions", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
