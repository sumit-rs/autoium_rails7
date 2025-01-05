class ResultCase < ApplicationRecord
  include ScreenshotHandlerConcern

  # -------------------------------------------------------------
  attr_accessor :mark_override
  attr_accessor :override_status_permanently

  # -------------------------------------------------------------
  belongs_to :results_dictionary, foreign_key: :rd_id
  belongs_to :test_case
  belongs_to :result_suite
  belongs_to :scheduler
  has_one :test_suite, through: :result_suite

  # -------------------------------------------------------------
  validates :override_comment, presence: true, if: proc { |record| record.mark_override.present? }

  # -------------------------------------------------------------
  after_save :populate_test_create_override, if: proc { |record| record.override_status_permanently }
  after_save :update_test_suite_and_scheduler_status, if: proc { |record| record.mark_override.present? }

  # -------------------------------------------------------------

  private

  def populate_test_create_override
    TestCaseOverride.create_override(self.test_case, self.error_description, self.override_comment)
  end
  def update_test_suite_and_scheduler_status
    result_suite = self.result_suite
    if result_suite.result_cases.where.not(rd_id: ResultsDictionary::STATUS[:SUCCESS]).count.zero?
      result_suite.update(rd_id: ResultsDictionary::STATUS[:SUCCESS])
      self.scheduler.update(status: Scheduler::SUCCESS_STATUS)
    end
  end
end
