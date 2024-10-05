class Project < ApplicationRecord

  # -------------------------------------------------------------
  encrypts :s3_access_key, :s3_secret_key, deterministic: true

  # -------------------------------------------------------------
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by'
  has_many :environments, dependent: :destroy
  has_many :project_team_members, dependent: :destroy
  has_many :assign_team_members, through: :project_team_members, source: :team_member
  has_many :test_roles, through: :environments
  has_many :test_plans, through: :environments

  # -------------------------------------------------------------
  validates :name, presence: true
  validates :s3_bucket_name, presence: true, if: proc { |project| project.save_to_s3 }
  validates :s3_secret_key, presence: true, if: proc { |project| project.save_to_s3 }
  validates :s3_access_key, presence: true, if: proc { |project| project.save_to_s3 }
  validates :s3_access_key, presence: true, if: proc { |project| project.save_to_s3 }

  # -------------------------------------------------------------
  after_create :create_project_team_member_as_creator

  private

  def create_project_team_member_as_creator
    self.project_team_members << ProjectTeamMember.new(team_member_id: self.created_by, project_id: self.id)
  end
end
