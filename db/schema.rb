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

ActiveRecord::Schema[7.2].define(version: 2024_10_10_135006) do
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

  create_table "test_cases", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "test_suite_id", null: false
    t.integer "custom_command_id"
    t.string "field_name"
    t.string "field_type"
    t.string "read_element"
    t.string "input_value"
    t.string "string"
    t.string "action"
    t.string "action_url"
    t.string "base_url"
    t.string "xpath"
    t.string "selenium_file"
    t.string "element_class"
    t.string "full_xpath"
    t.integer "sleeps"
    t.integer "priority"
    t.text "description"
    t.boolean "need_screenshot", default: false
    t.boolean "dependency", default: false
    t.boolean "new_tab", default: false
    t.boolean "enter_action", default: false
    t.boolean "javascript_conditional_enabled", default: false
    t.text "javascript_conditional"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_suite_id"], name: "index_test_cases_on_test_suite_id"
    t.index ["user_id"], name: "index_test_cases_on_user_id"
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

  create_table "test_suites", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "test_plan_id", null: false
    t.bigint "environment_id", null: false
    t.integer "base_suite_id"
    t.integer "post_suite_id"
    t.string "name"
    t.string "short_description"
    t.string "base_url"
    t.string "jira_id"
    t.text "video_file"
    t.text "description"
    t.text "flow_state"
    t.string "status"
    t.boolean "dependency", default: false
    t.boolean "is_stale", default: false
    t.boolean "is_automated", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["environment_id"], name: "index_test_suites_on_environment_id"
    t.index ["test_plan_id"], name: "index_test_suites_on_test_plan_id"
    t.index ["user_id"], name: "index_test_suites_on_user_id"
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

  add_foreign_key "test_cases", "test_suites"
  add_foreign_key "test_cases", "users"
  add_foreign_key "test_suites", "environments"
  add_foreign_key "test_suites", "test_plans"
  add_foreign_key "test_suites", "users"
end
