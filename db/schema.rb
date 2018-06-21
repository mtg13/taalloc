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

ActiveRecord::Schema.define(version: 2018_06_20_053958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "awaystudents", primary_key: ["id", "year", "sem"], force: :cascade do |t|
    t.string "id", limit: 11, null: false
    t.string "year", limit: 8, null: false
    t.integer "sem", null: false
    t.boolean "qualified"
    t.boolean "exemption"
    t.boolean "other"
    t.boolean "onleave"
  end

  create_table "config", primary_key: "attr", id: :string, limit: 20, force: :cascade do |t|
    t.string "value", limit: 20
  end

  create_table "coursenames", primary_key: "coursenum", id: :string, limit: 7, force: :cascade do |t|
    t.string "coursename", limit: 100
  end

  create_table "courses", primary_key: ["coursenum", "yearoffered", "sem"], force: :cascade do |t|
    t.string "coursenum", limit: 7, null: false
    t.string "coursename", limit: 100
    t.string "yearoffered", limit: 8, null: false
    t.integer "sem", limit: 2, null: false
    t.boolean "lab"
    t.boolean "pg"
    t.boolean "core"
    t.integer "registration"
  end

  create_table "extraalloc", primary_key: ["ta", "coursenum", "yearoffered", "semoffered"], force: :cascade do |t|
    t.string "ta", limit: 11, null: false
    t.string "coursenum", limit: 7, null: false
    t.string "yearoffered", limit: 8, null: false
    t.integer "semoffered", null: false
    t.integer "grade"
    t.string "comments", limit: 500
  end

  create_table "faculty", primary_key: "login", id: :string, limit: 20, force: :cascade do |t|
    t.string "name", limit: 20
  end

  create_table "instructor", primary_key: ["coursenum", "yearoffered", "semoffered", "instructor"], force: :cascade do |t|
    t.string "coursenum", limit: 7, null: false
    t.string "yearoffered", limit: 8, null: false
    t.integer "semoffered", limit: 2, null: false
    t.string "instructor", limit: 20, null: false
    t.string "description", limit: 2000
  end

  create_table "iprefs", primary_key: ["coursenum", "yearoffered", "semoffered", "id"], force: :cascade do |t|
    t.string "coursenum", limit: 7, null: false
    t.string "yearoffered", limit: 8, null: false
    t.integer "semoffered", null: false
    t.string "id", limit: 11, null: false
    t.integer "priority"
  end

  create_table "logindetails", primary_key: "uniqueiitdid", id: :string, limit: 20, force: :cascade do |t|
    t.string "userid", limit: 20
    t.string "mail", limit: 30
    t.string "name", limit: 50
    t.string "category", limit: 20
    t.string "department", limit: 20
  end

  create_table "sgpacgpa", primary_key: ["id", "year", "sem"], force: :cascade do |t|
    t.string "id", limit: 11, null: false
    t.string "year", limit: 8, null: false
    t.integer "sem", null: false
    t.float "sgpa"
    t.float "cgpa"
  end

  create_table "sprefs", primary_key: ["id", "coursenum", "yearoffered", "semoffered"], force: :cascade do |t|
    t.string "id", limit: 11, null: false
    t.string "coursenum", limit: 7, null: false
    t.string "yearoffered", limit: 8, null: false
    t.integer "semoffered", null: false
    t.integer "priority"
  end

  create_table "studentgrades", primary_key: ["id", "coursenum", "yearreg", "semreg"], force: :cascade do |t|
    t.string "id", limit: 11, null: false
    t.string "yearreg", limit: 8, null: false
    t.integer "semreg", null: false
    t.string "coursenum", limit: 7, null: false
    t.integer "grade"
  end

  create_table "students", id: :string, limit: 11, force: :cascade do |t|
    t.string "name", limit: 50
    t.boolean "sponsored"
    t.boolean "parttime"
    t.boolean "onleave"
    t.boolean "graduated"
    t.boolean "gate"
    t.string "entrynum", limit: 11
    t.boolean "mtechadv"
  end

  create_table "taalloc", primary_key: ["ta", "coursenum", "yearoffered", "semoffered"], force: :cascade do |t|
    t.string "ta", limit: 11, null: false
    t.string "coursenum", limit: 7, null: false
    t.string "yearoffered", limit: 8, null: false
    t.integer "semoffered", null: false
    t.integer "grade"
    t.string "comments", limit: 500
  end

  create_table "tacount", primary_key: ["coursenum", "yearoffered", "semoffered"], force: :cascade do |t|
    t.string "coursenum", limit: 7, null: false
    t.string "yearoffered", limit: 8, null: false
    t.integer "semoffered", null: false
    t.integer "phd"
    t.integer "msr"
    t.integer "dual"
    t.integer "mtech"
  end

  add_foreign_key "awaystudents", "students", column: "id", name: "awaystudents_id_fkey"
  add_foreign_key "courses", "coursenames", column: "coursenum", primary_key: "coursenum", name: "courses_fkey"
  add_foreign_key "extraalloc", "students", column: "ta", name: "extraalloc_ta_fkey", on_update: :cascade
  add_foreign_key "instructor", "courses", column: "coursenum", primary_key: "coursenum", name: "instructor_fkey", on_update: :cascade
  add_foreign_key "instructor", "faculty", column: "instructor", primary_key: "login", name: "instructor_name_fkey"
  add_foreign_key "iprefs", "courses", column: "coursenum", primary_key: "coursenum", name: "iprefs_coursenum_fkey"
  add_foreign_key "iprefs", "students", column: "id", name: "iprefs_id_fkey", on_update: :cascade
  add_foreign_key "sgpacgpa", "students", column: "id", name: "sgpacgpa_id_fkey", on_update: :cascade
  add_foreign_key "sprefs", "courses", column: "coursenum", primary_key: "coursenum", name: "sprefs_coursenum_fkey"
  add_foreign_key "sprefs", "students", column: "id", name: "sprefs_id_fkey", on_update: :cascade
  add_foreign_key "studentgrades", "coursenames", column: "coursenum", primary_key: "coursenum", name: "studentgrades_coursenum_fkey"
  add_foreign_key "studentgrades", "students", column: "id", name: "studentgrades_id_fkey", on_update: :cascade
  add_foreign_key "taalloc", "courses", column: "coursenum", primary_key: "coursenum", name: "taalloc_coursenum_fkey"
  add_foreign_key "taalloc", "students", column: "ta", name: "taalloc_ta_fkey", on_update: :cascade
  add_foreign_key "tacount", "courses", column: "coursenum", primary_key: "coursenum", name: "tacount_coursenum_fkey"
end
