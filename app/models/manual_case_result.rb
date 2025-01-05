class ManualCaseResult < ApplicationRecord
  include ScreenshotHandlerConcern

  #-------------------------------------------------------------
  STATUS_PASS = 'PASS'
  STATUS_FAIL = 'FAIL'
  STATUS = [STATUS_PASS, STATUS_FAIL]

  #-------------------------------------------------------------
  belongs_to :assign_manual_test_suite
  belongs_to :user, foreign_key: :assign_to
  belongs_to :manual_case
  has_one :test_suite, through: :manual_case, foreign_key: :test_suite_id

  #-------------------------------------------------------------
  after_save :update_assigned_suites

  private

  def update_assigned_suites
    manual_case_results = ManualCaseResult.where(assign_manual_test_suite: self.assign_manual_test_suite)
    pass_cases_count = manual_case_results.collect { |result| result if result.status == STATUS_PASS }.compact_blank.count
    fail_cases_count = manual_case_results.collect { |result| result if result.status == STATUS_FAIL }.compact_blank.count
    in_progress = manual_case_results.collect { |result| result if ['', nil].include?(result.status) }.compact_blank.count

    if in_progress == 0
      self.assign_manual_test_suite.state = AssignManualTestSuite::STATE_FINISH
    else
      self.assign_manual_test_suite.state = AssignManualTestSuite::STATE_PROGRESS
    end

    self.assign_manual_test_suite.fail_case_count = fail_cases_count
    self.assign_manual_test_suite.pass_case_count = pass_cases_count
    self.assign_manual_test_suite.save!
  end

end
