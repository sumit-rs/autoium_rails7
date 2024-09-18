class CreateEnvironments < ActiveRecord::Migration[7.2]
  def change
    create_table :environments do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.integer :project_id, null: false
      t.integer :user_id, null: false

      t.boolean :login_required, null: false, default: false
      t.text :user_name, null: true
      t.text :password, null: true
      t.string :login_field, null: true
      t.string :password_field, null: true
      t.string :action_button, null: true
      t.string :action_type, null: true
      t.string :user_email, null: true
      t.string :selenium_tester_url, null: true
      t.boolean :sleep_status, null: false, default: false

      t.string :git_branch, null: true
      t.string :git_orgranization, null: true
      t.string :git_provider, null: true
      t.string :git_repo_name, null: true
      t.string :git_last_commit, null: true
      t.text :git_access_token, null: true

      t.datetime :deleted_at, null: true
      t.timestamps
    end
    add_index :environments, :project_id, unique: true
  end
end
