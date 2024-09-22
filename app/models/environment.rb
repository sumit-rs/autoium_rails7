class Environment < ApplicationRecord

  # -------------------------------------------------------------
  encrypts :user_name, :password, :git_access_token, deterministic: true

  # -------------------------------------------------------------
  belongs_to :team_member
  belongs_to :project

  # -------------------------------------------------------------
  validates :name, presence: true
  validates :url, presence: true
end
