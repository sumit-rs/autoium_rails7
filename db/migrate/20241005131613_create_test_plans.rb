class CreateTestPlans < ActiveRecord::Migration[7.2]
  def change
    create_table :test_plans do |t|
      t.integer :environment_id, null: false
      t.integer :user_id, null: false
      t.string :name, null: false
      t.text :description
      t.integer :suite_count, null: false, default: 0
      t.text :additional_information
      t.boolean :status, null: false, default: true
      t.timestamps
    end
  end
end
