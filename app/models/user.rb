class User < ApplicationRecord
  has_secure_password

  # -------------------------------------------------------------
  ADMIN_ROLE = 'ADMIN'.freeze
  USER_ROLE = 'USER'.freeze
  GUEST_ROLE = 'GUEST'.freeze

  #-------------------------------------------------------------
  attr_accessor :project_id, :allow_generate_password

  # -------------------------------------------------------------
  store :additional_info, accessors: [:prefer_project, :prefer_environment], coder: JSON

  # -------------------------------------------------------------
  has_many :projects, class_name: 'Project', foreign_key: 'created_by', dependent: :destroy
  has_many :project_team_members, dependent: :destroy, foreign_key: 'team_member_id'
  #this return project roles where user belongs to different - 2 projects
  has_many :assign_projects, class_name: 'Project', foreign_key: 'project_id', through: :project_team_members
  has_many :environments, dependent: :destroy
  has_many :test_roles, dependent: :destroy
  has_many :test_plans, dependent: :destroy
  has_many :test_suites, dependent: :destroy
  has_many :assign_manual_test_suites, foreign_key: 'assign_to', dependent: :destroy
  has_many :test_cases, dependent: :destroy

  # -------------------------------------------------------------
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  # -------------------------------------------------------------
  before_validation :populate_user_password, if: Proc.new{|record| record.allow_generate_password}
  after_create :populate_project_team_member
  after_commit :send_invitation_mail, on: [:update, :create], if: Proc.new{|record| record.invitation_sent.present? and record.invitation_token.present?}

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  def self.generate_jwt_token(email)
    payload = {email: email}
    JsonWebToken.encode(payload)
  end

  def is_admin?
    self.role == ADMIN_ROLE
  end

  def self.random_token(length = 10)
    SecureRandom.hex(length)
  end

  private

  def password_required?
    password_digest.blank? || !password.nil?
  end

  def populate_user_password
    _password = User.random_token
    self.password = _password
    self.password_confirmation = _password
    _password
  end
  def populate_project_team_member
    self.project_team_members << ProjectTeamMember.new(project_id: self.project_id, team_member: self)
  end

  def send_invitation_mail
    Thread.new { NotifyMailer.invitation_link(self).deliver_now }
  end

end
