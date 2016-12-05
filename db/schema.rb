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

ActiveRecord::Schema.define(version: 20161129161632) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "form_responses", force: :cascade do |t|
    t.integer  "form_id"
    t.string   "user"
    t.string   "status"
    t.string   "json_response"
    t.date     "json_updated_at"
    t.date     "sent_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["form_id"], name: "index_form_responses_on_form_id", using: :btree
  end

  create_table "forms", force: :cascade do |t|
    t.string   "reference_model"
    t.string   "description"
    t.string   "status"
    t.date     "open_at"
    t.date     "close_at"
    t.integer  "max_attemps"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "vagas_remanescentes_activities", force: :cascade do |t|
    t.string   "name"
    t.integer  "vagas_remanescentes_course_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["vagas_remanescentes_course_id"], name: "index_vagas_remanescentes_activities_on_courses_id", using: :btree
  end

  create_table "vagas_remanescentes_classes", force: :cascade do |t|
    t.string   "name"
    t.integer  "vagas_remanescentes_course_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["vagas_remanescentes_course_id"], name: "index_vagas_remanescentes_classes_on_courses_id", using: :btree
  end

  create_table "vagas_remanescentes_courses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "form_responses", "forms"
  add_foreign_key "vagas_remanescentes_activities", "vagas_remanescentes_courses"
  add_foreign_key "vagas_remanescentes_classes", "vagas_remanescentes_courses"
 
  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "name"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "identities", "users", on_delete: :cascade
end
