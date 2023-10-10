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

ActiveRecord::Schema[7.0].define(version: 2023_09_23_173134) do
  create_table "event_attendees", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_attendees_on_event_id"
    t.index ["user_id", "event_id"], name: "index_event_attendees_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_event_attendees_on_user_id"
  end

  create_table "event_bookmarks", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_bookmarks_on_event_id"
    t.index ["user_id", "event_id"], name: "index_event_bookmarks_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_event_bookmarks_on_user_id"
  end

  create_table "event_comments", charset: "utf8mb4", force: :cascade do |t|
    t.text "comment"
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_comments_on_event_id"
    t.index ["user_id"], name: "index_event_comments_on_user_id"
  end

  create_table "events", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "date_type", null: false
    t.time "start_time"
    t.time "end_time"
    t.string "place", null: false
    t.string "latitude", null: false
    t.string "longitude", null: false
    t.string "official_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title", "start_date", "place"], name: "index_events_on_title_and_start_date_and_place", unique: true
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "profiles", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.text "bio", null: false
    t.string "avatar"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "record_bookmarks", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_id"], name: "index_record_bookmarks_on_record_id"
    t.index ["user_id", "record_id"], name: "index_record_bookmarks_on_user_id_and_record_id", unique: true
    t.index ["user_id"], name: "index_record_bookmarks_on_user_id"
  end

  create_table "record_comments", charset: "utf8mb4", force: :cascade do |t|
    t.text "comment", null: false
    t.bigint "user_id", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_id"], name: "index_record_comments_on_record_id"
    t.index ["user_id"], name: "index_record_comments_on_user_id"
  end

  create_table "record_likes", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_id"], name: "index_record_likes_on_record_id"
    t.index ["user_id", "record_id"], name: "index_record_likes_on_user_id_and_record_id", unique: true
    t.index ["user_id"], name: "index_record_likes_on_user_id"
  end

  create_table "record_tags", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "record_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_id", "tag_id"], name: "index_record_tags_on_record_id_and_tag_id", unique: true
    t.index ["record_id"], name: "index_record_tags_on_record_id"
    t.index ["tag_id"], name: "index_record_tags_on_tag_id"
  end

  create_table "records", charset: "utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.string "image"
    t.boolean "base", default: true, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_records_on_user_id"
  end

  create_table "related_records", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "record_id", null: false
    t.integer "related_record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_id"], name: "index_related_records_on_record_id"
    t.index ["related_record_id", "record_id"], name: "index_related_records_on_related_record_id_and_record_id", unique: true
  end

  create_table "tags", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "event_attendees", "events"
  add_foreign_key "event_attendees", "users"
  add_foreign_key "event_bookmarks", "events"
  add_foreign_key "event_bookmarks", "users"
  add_foreign_key "event_comments", "events"
  add_foreign_key "event_comments", "users"
  add_foreign_key "events", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "record_bookmarks", "records"
  add_foreign_key "record_bookmarks", "users"
  add_foreign_key "record_comments", "records"
  add_foreign_key "record_comments", "users"
  add_foreign_key "record_likes", "records"
  add_foreign_key "record_likes", "users"
  add_foreign_key "record_tags", "records"
  add_foreign_key "record_tags", "tags"
  add_foreign_key "records", "users"
  add_foreign_key "related_records", "records"
end
