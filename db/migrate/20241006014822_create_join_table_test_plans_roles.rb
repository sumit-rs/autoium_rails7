class CreateJoinTableTestPlansRoles < ActiveRecord::Migration[7.2]
  def change
    create_join_table :test_plans, :test_roles do |t|
      t.index [:test_plan_id, :test_role_id]
    end
  end
end
