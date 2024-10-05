class Environment < ApplicationRecord

  # -------------------------------------------------------------
  ACTION_TYPE_ID = 'id'.freeze
  ACTION_TYPE_NAME = 'name'.freeze
  ACTION_TYPE_XPATH = 'X-Path'.freeze
  ACTION_TYPES = [ACTION_TYPE_ID, ACTION_TYPE_NAME, ACTION_TYPE_XPATH]

  GIT_PROVIDER = 'GIT'
  BITBUCKET_PROVIDER = 'BITBUCKET'
  PROVIDERS = [GIT_PROVIDER, BITBUCKET_PROVIDER]

  # -------------------------------------------------------------
  encrypts :user_name, :password, :git_access_token, deterministic: true

  # -------------------------------------------------------------
  attr_accessor :observe_git_branch

  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :project
  has_many :custom_commands
  has_many :test_roles, dependent: :destroy
  has_many :test_plans, dependent: :destroy

  # -------------------------------------------------------------
  validates :name, presence: true
  validates :url, presence: true
  validates :user_name, presence: true, if: proc { |record| record.login_required? }
  validates :password, presence: true, if: proc { |record| record.login_required? }
  validates :login_field, presence: true, if: proc { |record| record.login_required? }
  validates :password_field, presence: true, if: proc { |record| record.login_required? }
  validates :action_button, presence: true, if: proc { |record| record.login_required? }
  validates :action_type, presence: true, if: proc { |record| record.login_required? }
  validates :user_email, presence: true, if: proc { |record| record.login_required? }

  validates :git_provider, presence: true, if: proc { |record| record.observe_git_branch === true }
  validates :git_branch, presence: true, if: proc { |record| record.observe_git_branch === true }
  validates :git_repo_name, presence: true, if: proc { |record| record.observe_git_branch === true }
  validates :git_access_token, presence: true, if: proc { |record| record.observe_git_branch === true }

end
