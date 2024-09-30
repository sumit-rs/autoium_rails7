class ProjectTeamMember < ApplicationRecord

  # -------------------------------------------------------------
  belongs_to :project
  belongs_to :team_member, class_name: 'User', foreign_key: 'team_member_id'
  belongs_to :assign_project, class_name: 'Project', foreign_key: 'project_id', optional: true
  # -------------------------------------------------------------
end
