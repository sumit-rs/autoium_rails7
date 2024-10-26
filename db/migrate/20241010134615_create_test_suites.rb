class CreateTestSuites < ActiveRecord::Migration[7.2]
  def change
    create_table :test_suites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :test_plan, null: false, foreign_key: true
      t.references :environment, null: false, foreign_key: true
      t.integer :base_suite_id
      t.integer :post_suite_id
      t.string :name
      t.string :short_description
      t.string :base_url
      t.string :jira_id
      t.text :video_file
      t.text :description
      t.text :flow_state
      t.string :status
      t.boolean :dependency, default: false
      t.boolean :is_stale, default: false
      t.boolean :is_automated, default: false
      t.timestamps
    end
  end
end
