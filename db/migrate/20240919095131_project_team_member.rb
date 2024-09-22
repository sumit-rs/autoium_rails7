class ProjectTeamMember < ActiveRecord::Migration[7.2]
  def change
    create_table :project_team_members do |t|
      t.integer :project_id, null: false
      t.integer :team_member_id, null: false
      t.integer :project_access_role_id, null: false

      t.timestamps
    end
  end
end
