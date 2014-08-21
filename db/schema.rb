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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140821041757) do

  create_table "answers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.string   "result"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "topic"
    t.integer  "practicesession_id"
    t.string   "title"
    t.string   "difficulty"
    t.string   "studentanswer"
  end

  create_table "lessons", :force => true do |t|
    t.string   "title"
    t.string   "length"
    t.string   "url"
    t.string   "platform"
    t.string   "thumbnail"
    t.string   "nextlesson"
    t.string   "topic"
    t.integer  "order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "related"
    t.integer  "topic_id"
  end

  create_table "practice_sessions", :force => true do |t|
    t.string   "question_pool"
    t.string   "subjects"
    t.integer  "number_of_questions"
    t.integer  "number_correct"
    t.integer  "number_incorrect"
    t.integer  "user_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "questions", :force => true do |t|
    t.text     "prompt"
    t.string   "image"
    t.string   "supplement"
    t.string   "title"
    t.string   "difficulty"
    t.string   "topic"
    t.string   "correct_response"
    t.string   "incorrect_one"
    t.string   "incorrect_two"
    t.string   "incorrect_three"
    t.string   "video_explanation"
    t.text     "text_explanation"
    t.string   "other_explanation"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "questiontolessons", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "question_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "topics", :force => true do |t|
    t.integer  "lesson_id"
    t.string   "name"
    t.integer  "order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "userstats", :force => true do |t|
    t.string   "permissions"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
