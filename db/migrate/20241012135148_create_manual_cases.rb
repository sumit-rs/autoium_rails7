class CreateManualCases < ActiveRecord::Migration[7.2]
  def change
    create_table :manual_cases do |t|
      t.references :test_suite, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :url
      t.boolean :is_active
      t.timestamps
    end
  end
end
