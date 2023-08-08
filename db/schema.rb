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

ActiveRecord::Schema[7.0].define(version: 2023_08_02_073322) do
  create_table "profiles", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "avatar", null: false
    t.text "bio", null: false
    t.integer "role", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
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
    t.index ["related_record_id"], name: "index_related_records_on_related_record_id", unique: true
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "profiles", "users"
  add_foreign_key "records", "users"
  add_foreign_key "related_records", "records"
end
