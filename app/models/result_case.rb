class ResultCase < ApplicationRecord

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
  def upload_screenshot(file)
    return { status: false, message: 'Please select a file!' } unless file.present?
    return { status: false, message: 'Invalid image format! Please upload a PNG image!' } unless file.content_type == 'image/png'

    file_name = "#{SecureRandom.uuid.gsub('-', '')}.png"
    old_file_name = self.screenshot_file_location

    _folder_path = 'screenshots'
    environment = self.test_suite.environment
    project = environment.project

    FileUploader.upload(file.tempfile, project.id, environment.id, _folder_path, file_name)
    self.update(screenshot_file_location: file_name)

    FileUploader.delete(project.id, environment.id, _folder_path, old_file_name) if old_file_name.present?

    { status: true, message: 'Screenshot uploaded successfully!' }
  end

  def get_screenshot_url
    return '' unless self.screenshot_file_location.present?

    environment = self.test_suite.environment
    project = environment.project
    FileUploader.retrieve(project.id, environment.id, 'screenshots', self.screenshot_file_location)
  end

  private

  def populate_test_create_override
    #Todo: it should call only when override status marked permanently
    puts self.override_status_permanently.inspect
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
