class CreateResultCases < ActiveRecord::Migration[7.2]
  def change
    create_table :result_cases do |t|
      t.integer :rd_id
      t.integer :test_case_id
      t.integer :result_suite_id
      t.integer :scheduler_id
      t.text :screenshot_file_location
      t.text :error_description
      t.boolean :email_sent, default: false
      t.boolean :override_status, default: false
      t.string :override_comment
      t.timestamps
    end
  end
end
