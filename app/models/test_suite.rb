class TestSuite < ApplicationRecord

  # -------------------------------------------------------------
  SUITE_FINAL_STATUS = 'Final'
  SUITE_DRAFT_STATUS = 'Draft'
  SUITE_STATUS = [SUITE_DRAFT_STATUS, SUITE_FINAL_STATUS]
  CHROME_PLATFORM = 'CHROME'
  WEB_PLATFORM = 'WEB'

  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :environment
  belongs_to :test_plan, optional: true
  belongs_to :base_suite, class_name: 'TestSuite', foreign_key: :base_suite_id, optional: true
  belongs_to :post_suite, class_name: 'TestSuite', foreign_key: :post_suite_id, optional: true
  has_many  :manual_cases, dependent: :destroy
  has_many  :test_cases, dependent: :destroy
  has_many :assign_manual_test_suites, dependent: :destroy
  has_many :schedulers, dependent: :destroy

  # -------------------------------------------------------------
  attr_accessor :platform

  # -------------------------------------------------------------
  validates :name, presence: true
  validates :short_description, presence: true, unless: proc { |suite| suite.platform == CHROME_PLATFORM }
  validate :check_presence_of_test_plan, unless: proc { |suite| suite.platform == CHROME_PLATFORM }

  # -------------------------------------------------------------
  before_save :populate_default_value_based_platform

  def include_base_post_suite
    [self.base_suite, self, self.post_suite].compact_blank
  end

  private

  def check_presence_of_test_plan
    self.errors.add(:base, "Test plan can't be blank") unless self.test_plan.present?
  end
  def populate_default_value_based_platform
    if platform == TestSuite::CHROME_PLATFORM
      self.short_description = 'Created test suite through chrome.'
      self.is_automated = true
      self.status = TestSuite::SUITE_DRAFT_STATUS
    end
  end
end
