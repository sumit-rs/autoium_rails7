class ProjectAccessRole < ApplicationRecord

  # -------------------------------------------------------------
  DEFAULT_ACCESS_ROLES = 'default'.freeze

  #-------------------------------------------------------------

  # -------------------------------------------------------------
  belongs_to :project
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by'
  has_many :project_team_members, foreign_key: 'project_access_role_id', class_name: 'ProjectTeamMember'
  has_many :assign_team_members, through: :project_team_members, source: :team_member

  # -------------------------------------------------------------
  validates :name, presence: true

  # -------------------------------------------------------------
  #before_destroy :last_role_4_project_not_deleted

  private
  def last_role_4_project_not_deleted
    if ProjectAccessRole.where(project_id: self.project_id).count == 1
      self.errors.add(:base, 'System does not delete last project access role..')
      raise ActiveRecord::RecordNotDestroyed, 'Can\'t delete last project access role.'
    end
  end

end
