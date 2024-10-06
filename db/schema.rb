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

ActiveRecord::Schema[7.2].define(version: 2024_10_06_014822) do
  create_table "custom_commands", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "environment_id", null: false
    t.string "name", null: false
    t.string "command", null: false
    t.text "additional_information"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "environments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.integer "project_id", null: false
    t.integer "user_id", null: false
    t.boolean "login_required", default: false, null: false
    t.text "user_name"
    t.text "password"
    t.string "login_field"
    t.string "password_field"
    t.string "action_button"
    t.string "action_type"
    t.string "user_email"
    t.string "selenium_tester_url"
    t.boolean "sleep_status", default: false, null: false
    t.string "git_provider"
    t.string "git_branch"
    t.string "git_organization"
    t.string "git_repo_name"
    t.string "git_last_commit"
    t.text "git_access_token"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_environments_on_project_id", unique: true
  end

  create_table "project_team_members", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "team_member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "created_by", null: false
    t.boolean "save_to_s3", default: false
    t.string "s3_bucket_name"
    t.text "s3_access_key"
    t.text "s3_secret_key"
    t.string "s3_region_name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_plan_steps", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "test_plan_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_plans", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "environment_id", null: false
    t.integer "user_id", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "suite_count", default: 0, null: false
    t.text "additional_information"
    t.boolean "status", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_plans_roles", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "test_plan_id", null: false
    t.bigint "test_role_id", null: false
    t.index ["test_plan_id", "test_role_id"], name: "index_test_plans_roles_on_test_plan_id_and_test_role_id"
  end

  create_table "test_roles", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "environment_id", null: false
    t.string "name", null: false
    t.text "description"
    t.boolean "status", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end
end
