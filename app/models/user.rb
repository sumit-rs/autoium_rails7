class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # -------------------------------------------------------------
  ADMIN_ROLE = 'ADMIN'.freeze
  USER_ROLE = 'USER'.freeze
  GUEST_ROLE = 'GUEST'.freeze

  #-------------------------------------------------------------
  attr_accessor :project_id, :project_access_role_id, :allow_generate_password

  # -------------------------------------------------------------
  has_many :projects, class_name: 'Project', foreign_key: 'created_by', dependent: :destroy
  has_many :project_team_members, dependent: :destroy, foreign_key: 'team_member_id'
  #this return those access roles which created by user.
  has_many :project_access_roles, foreign_key: 'created_by'

  #this return project roles where user belongs to different - 2 projects
  has_many :assign_projects, class_name: 'Project', foreign_key: 'project_id', through: :project_team_members
  has_many :assign_project_roles, class_name: 'ProjectAccessRole', foreign_key: 'team_member_id', through: :project_team_members do
    #through we can get user role for the project
    def user_project(project)
      where(project: project).take
    end
  end

  has_many :environments, dependent: :destroy


  # -------------------------------------------------------------
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }


  # -------------------------------------------------------------
  before_validation :populate_user_password, if: Proc.new{|record| record.allow_generate_password}
  after_create :populate_project_team_member

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  private

  def populate_user_password
    self.password = SecureRandom.hex(10)
  end
  def populate_project_team_member
    self.project_team_members << ProjectTeamMember.new(project_id: self.project_id, project_access_role_id: self.project_access_role_id, team_member: self)
  end

end
