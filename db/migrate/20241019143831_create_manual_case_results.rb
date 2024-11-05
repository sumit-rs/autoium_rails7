class CreateManualCaseResults < ActiveRecord::Migration[7.2]
  def change
    create_table :manual_case_results do |t|
      t.references :assign_manual_test_suite, null: false
      t.references :manual_case, null: false
      t.integer :assign_to, null: false
      t.text :description
      t.string :status
      t.timestamps
    end
  end
end
