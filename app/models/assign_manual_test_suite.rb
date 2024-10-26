class AssignManualTestSuite < ApplicationRecord
  #-------------------------------------------------------------
  STATE_ASSIGN = 'ASSIGN'
  STATE_START = 'START'
  STATE_PROGRESS = 'IN-PROGRESS'
  STATE_FINISH = 'FINISH'

  BROWSER_CHROME = 'CHROME'
  BROWSER_EDGE = 'EDGE'
  BROWSER_FIREFOX = 'FIREFOX'
  BROWSER_SAFARI = 'SAFARI'
  BROWSERS = [BROWSER_CHROME, BROWSER_EDGE, BROWSER_FIREFOX, BROWSER_SAFARI]

  #-------------------------------------------------------------
  belongs_to :test_suite
  belongs_to :user, foreign_key: :assign_to
  has_many :manual_case_results, dependent: :destroy
  has_one :environment, through: :test_suite

  #-------------------------------------------------------------
  validates :browser, presence: true

  #-------------------------------------------------------------
  before_create :assign_manual_test_suite_cases

  private
  def assign_manual_test_suite_cases

  end
end
