class CreateTestRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :test_roles do |t|
      t.string :user_id, null: false
      t.string :environment_id, null: false
      t.string :name, null: false
      t.text :description
      t.boolean :status, null: false, default: true
      t.timestamps
    end
  end
end
