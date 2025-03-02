class CreateTestPlanFlows < ActiveRecord::Migration[7.2]
  def change
    create_table :test_plan_flows do |t|
      t.integer :test_plan_id
      t.integer :link_test_plan_id
      t.timestamps
    end
  end
end
