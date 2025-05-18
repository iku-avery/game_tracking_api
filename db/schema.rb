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

ActiveRecord::Schema[8.0].define(version: 2025_05_18_112310) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "players", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "playthroughs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "player_id", null: false
    t.datetime "started_at", null: false
    t.decimal "score", precision: 12, scale: 2, null: false
    t.float "time_spent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id", "score"], name: "index_playthroughs_on_player_id_and_score"
    t.index ["player_id", "started_at"], name: "index_playthroughs_on_player_id_and_started_at"
    t.index ["player_id"], name: "index_playthroughs_on_player_id"
    t.index ["started_at", "player_id"], name: "index_playthroughs_on_started_at_and_player_id"
  end

  add_foreign_key "playthroughs", "players"
end
