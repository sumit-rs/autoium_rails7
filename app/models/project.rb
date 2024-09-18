class Project < ApplicationRecord

  # -------------------------------------------------------------
  encrypts :s3_access_key, :s3_secret_key, deterministic: true

  # -------------------------------------------------------------
  belongs_to :user
  has_many :environements, dependent: :destroy

  # -------------------------------------------------------------
  validates :name, presence: true
  validates :s3_bucket_name, presence: true, if: proc { |project| project.save_to_s3 }
  validates :s3_secret_key, presence: true, if: proc { |project| project.save_to_s3 }
  validates :s3_access_key, presence: true, if: proc { |project| project.save_to_s3 }
  validates :s3_access_key, presence: true, if: proc { |project| project.save_to_s3 }
end
