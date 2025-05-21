class CreateSuiteSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :suite_schedules do |t|
      t.integer "test_suite_id"
      t.string "name"
      t.date "start_date"
      t.date "end_date"
      t.string "time"
      t.string "status"
      t.text "additional_info"
      t.boolean "active", default: true
      t.timestamps
    end
  end
end
