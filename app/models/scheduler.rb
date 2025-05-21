class Scheduler < ApplicationRecord

  # -------------------------------------------------------------
  READY_STATUS = 'READY'
  ERROR_STATUS = 'ERROR'
  RUNNING_STATUS = 'RUNNING'
  COMPLETE_STATUS = 'COMPLETE'
  SUCCESS_STATUS = 'SUCCESS'

  STATUS = [READY_STATUS, ERROR_STATUS, RUNNING_STATUS, SUCCESS_STATUS]

  # -------------------------------------------------------------
  belongs_to :user, optional: true
  belongs_to :test_suite
  belongs_to :browser
  has_many :result_suites

  # -------------------------------------------------------------
  validate :check_test_suite_type
  validate :check_presence_selenium_tester_url
  #validate :check_presence_selenium_application #java application
  # -------------------------------------------------------------

  before_create :assign_default_status
  before_create :assign_start_date
  after_create :scheduled_now
  before_save :populate_record_session
  # -------------------------------------------------------------
  def check_test_suite_type
    self.errors.add(:base, 'Test suite type must be automated.') unless self.test_suite.is_automated?
  end

  def check_presence_selenium_tester_url
    self.errors.add(:base, 'Selenium test path must be configured with corresponding test suite environment.') unless self.test_suite.environment.selenium_tester_url.present?
  end

  def check_presence_selenium_application
    if (java_app_path = self.test_suite.environment.selenium_tester_url).present? and (not Dir.exist?(File.dirname(java_app_path)))
      self.errors.add(:base, 'Selenium java application must be configured.')
    end
  end

  def assign_default_status
    self.status = Scheduler::READY_STATUS
  end

  def assign_start_date
    self.scheduled_date = DateTime.now.utc.strftime('%Y-%m-%d %H:%M')
  end

  def populate_record_session
    self.record_session = false if self.number_of_times > 1
  end
  def scheduled_now
    _test_suite = self.test_suite

    return unless _test_suite.present? and _test_suite.status.present?
    return if _test_suite.status == TestSuite::SUITE_FINAL_STATUS and _test_suite.is_automated == false
    return unless (tester_path = _test_suite.environment.selenium_tester_url).present?

    file_directory = File.dirname(tester_path)
    return unless Dir.exist?(file_directory)

    mode = 'headless'
    Dir.chdir(file_directory) do
      Process.fork { system("#{tester_path} #{mode} #{self.id}") }
    end
  end

  def video_file
    return nil unless self.record_session.present?

    self.result_suites.where.not(video_file: nil).pluck(:video_file).last
  end

  def video_file_url
    _file_name = self.video_file
    return '' unless _file_name.present?

    environment = self.test_suite.environment
    project = environment.project
    FileUploader.retrieve(project.id, environment.id, 'videos', _file_name)
  end
end
