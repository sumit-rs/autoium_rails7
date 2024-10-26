class CreateAssignManualTestSuites < ActiveRecord::Migration[7.2]
  def change
    create_table :assign_manual_test_suites do |t|
      t.integer :assign_to, null: false
      t.references :test_suite, null: false, foreign_key: true
      t.integer :assign_number
      t.string :state
      t.string :browser
      t.integer :fail_case_count
      t.integer :pass_case_count
      t.timestamps
    end
  end
end
