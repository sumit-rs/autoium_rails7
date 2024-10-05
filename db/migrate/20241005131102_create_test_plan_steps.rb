class CreateTestPlanSteps < ActiveRecord::Migration[7.2]
  def change
    create_table :test_plan_steps do |t|
      t.integer :test_plan_id, null: false
      t.string :name, null: false
      t.text :description
      t.timestamps
    end
  end
end
