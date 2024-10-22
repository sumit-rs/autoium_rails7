class TestSuite < ApplicationRecord

  # -------------------------------------------------------------
  SUITE_FINAL_STATUS = 'Final'
  SUITE_DRAFT_STATUS = 'Draft'
  SUITE_STATUS = [SUITE_DRAFT_STATUS, SUITE_FINAL_STATUS]

  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :environment
  belongs_to :test_plan
  belongs_to :base_suite, class_name: 'TestSuite', foreign_key: :base_suite_id
  belongs_to :post_suite, class_name: 'TestSuite', foreign_key: :post_suite_id
  has_many  :manual_cases, dependent: :destroy
  has_many :assign_manual_test_suites, dependent: :destroy

  # -------------------------------------------------------------
  validates :name, presence: true

  def include_base_post_suite
    [self.base_suite, self, self.post_suite].compact_blank
  end
end
