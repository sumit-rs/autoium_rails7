class CreateManualCaseResults < ActiveRecord::Migration[7.2]
  def change
    create_table :manual_case_results do |t|
      t.references :assign_manual_test_suite, null: false, foreign_key: true
      t.references :manual_case, null: false, foreign_key: true
      t.integer :assign_to, null: false
      t.text :description
      t.string :status
      t.timestamps
    end
  end
end
