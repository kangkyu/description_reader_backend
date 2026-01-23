# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_23_062651) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "amazon_links", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "summary_id", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["summary_id"], name: "index_amazon_links_on_summary_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.string "token"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["token"], name: "index_sessions_on_token", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "summaries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "summary_text"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "video_id"
    t.string "video_title"
    t.string "video_url"
    t.index ["user_id", "video_id"], name: "index_summaries_on_user_id_and_video_id", unique: true
    t.index ["user_id"], name: "index_summaries_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "amazon_links", "summaries"
  add_foreign_key "sessions", "users"
  add_foreign_key "summaries", "users"
end
