class TestSuite < ApplicationRecord

  # -------------------------------------------------------------
  SUITE_FINAL_STATUS = 'Final'
  SUITE_DRAFT_STATUS = 'Draft'
  SUITE_STATUS = [SUITE_DRAFT_STATUS, SUITE_FINAL_STATUS]

  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :environment
  belongs_to :test_plan
  has_many  :manual_cases, dependent: :destroy

  # -------------------------------------------------------------
  validates :name, presence: true
end
