class CreateTestCaseOverrides < ActiveRecord::Migration[7.2]
  def change
    create_table :test_case_overrides do |t|
      t.integer :test_case_id
      t.text :error_message
      t.text :override_message
      t.string :error_hash
      t.timestamps
    end
  end
end
