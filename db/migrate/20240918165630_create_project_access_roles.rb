class CreateProjectAccessRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :project_access_roles do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :project_id, null: false
      t.integer :created_by, null: false

      t.timestamps
    end
  end
end
