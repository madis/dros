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

ActiveRecord::Schema.define(version: 20170110194946) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contributions", force: :cascade do |t|
    t.string   "author",     null: false
    t.integer  "week",       null: false
    t.integer  "additions",  null: false
    t.integer  "deletions",  null: false
    t.integer  "commits",    null: false
    t.integer  "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_contributions_on_project_id", using: :btree
  end

  create_table "data_requests", force: :cascade do |t|
    t.string   "slug",                   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status",     default: 0, null: false
  end

  create_table "project_stats", force: :cascade do |t|
    t.float    "weekly_commits_per_contributor_min", default: 0.0, null: false
    t.float    "weekly_commits_per_contributor_max", default: 0.0, null: false
    t.float    "weekly_commits_per_contributor_avg", default: 0.0, null: false
    t.float    "weekly_commits_per_contributor_med", default: 0.0, null: false
    t.integer  "project_id",                                       null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.index ["project_id"], name: "index_project_stats_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "owner",                  null: false
    t.string   "repo",                   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "health",     default: 0, null: false
  end

  create_table "repo_infos", force: :cascade do |t|
    t.string   "description"
    t.integer  "size"
    t.integer  "watchers"
    t.integer  "stars"
    t.integer  "forks"
    t.string   "language"
    t.integer  "project_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["project_id"], name: "index_repo_infos_on_project_id", using: :btree
  end

  add_foreign_key "contributions", "projects"
  add_foreign_key "project_stats", "projects"
  add_foreign_key "repo_infos", "projects"
end
