class CreateResultSuites < ActiveRecord::Migration[7.2]
  def change
    create_table :result_suites do |t|
      t.integer :rd_id
      t.integer :test_suite_id
      t.integer :user_id
      t.integer :scheduler_id
      t.integer :scheduler_index, default: -1
      t.string :video_file
      t.timestamp :start_time
      t.timestamp :end_time
      t.timestamps
    end
  end
end
