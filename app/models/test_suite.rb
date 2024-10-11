class TestSuite < ApplicationRecord

  # -------------------------------------------------------------
  SUITE_FINAL_STATUS = 'Final'
  SUITE_DRAFT_STATUS = 'Draft'
  SUITE_STATUS = [SUITE_DRAFT_STATUS, SUITE_FINAL_STATUS]

  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :environment
  belongs_to :test_plan

  # -------------------------------------------------------------
  validates :name, presence: true
end
