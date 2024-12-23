class ProjectTeamMember < ApplicationRecord

  # -------------------------------------------------------------
  belongs_to :project
  belongs_to :team_member, class_name: 'User', foreign_key: 'team_member_id'
  belongs_to :assign_project, class_name: 'Project', foreign_key: 'project_id', optional: true
  # -------------------------------------------------------------

  before_destroy :at_least_one_project_member_present
  # -------------------------------------------------------------


  def at_least_one_project_member_present
    self.errors.add(:base, 'At-least one project member must be present') if self.project.project_team_members.count == 1
    throw :abort
  end
end
