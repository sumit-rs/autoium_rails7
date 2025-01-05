require 'csv'
class TestSuite < ApplicationRecord

    # -------------------------------------------------------------
    SUITE_FINAL_STATUS = 'Final'
    SUITE_DRAFT_STATUS = 'Draft'
    SUITE_STATUS = [SUITE_DRAFT_STATUS, SUITE_FINAL_STATUS]
    CHROME_PLATFORM = 'CHROME'
    WEB_PLATFORM = 'WEB'
    IMPORT_FILE_TYPE = ['text/csv','application/csv']

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
    attr_accessor :import_suite_cases

    # -------------------------------------------------------------
    validates :name, presence: true
    validates :short_description, presence: true, unless: proc { |suite| suite.platform == CHROME_PLATFORM }
    validate :check_presence_of_test_plan, if: proc { |suite| suite.platform == WEB_PLATFORM }
    validate :check_import_test_suite_file_type
    validate :check_import_test_suite_file_header

    # -------------------------------------------------------------
    before_save :populate_test_cases_import
    before_save :populate_default_short_desc_based_platform

    def include_base_post_suite
      [self.base_suite, self, self.post_suite].compact_blank
    end

    def is_manual_suite?
      !self.is_automated?
    end

    def video_file_url
      return '' unless self.video_file.present?

      project_id = self.environment.project.id
      FileUploader.retrieve(project_id, self.environment_id, 'videos', self.video_file)
    end

    private

    def check_presence_of_test_plan
      self.errors.add(:base, "Test plan can't be blank") unless self.test_plan.present?
    end
    def check_import_test_suite_file_type
      if self.import_suite_cases.present? and !TestSuite::IMPORT_FILE_TYPE.include?(self.import_suite_cases.content_type)
        errors.add(:base, "Please select a valid import file, only CSV type supported")
      end
    end

    def check_import_test_suite_file_header
      if self.import_suite_cases.present? and TestSuite::IMPORT_FILE_TYPE.include?(self.import_suite_cases.content_type)
        headers = CSV.open(self.import_suite_cases, :headers => true).read.headers
        if self.is_automated and !headers.include?("field_name")
          self.errors.add(:base, "CSV headers are invalid. It should have field_name for automate test suite.")
        elsif self.is_automated == false and !headers.include?("name")
          self.errors.add(:base, "CSV headers are invalid. It should have name for manual test suite.")
        end
      end
    end

    def populate_default_short_desc_based_platform
      if self.platform == TestSuite::CHROME_PLATFORM
        self.short_description ||= 'Created test suite through chrome.'
        self.status = TestSuite::SUITE_DRAFT_STATUS
      end
    end
    def populate_test_cases_import
      if self.import_suite_cases.present? and TestSuite::IMPORT_FILE_TYPE.include?(self.import_suite_cases.content_type)
        errors = []
        data_row = 1

        CSV.foreach(self.import_suite_cases, headers: true) do |row|
          test_case = row.to_h
          test_case = test_case.merge("priority" => (test_case["sequence"] || test_case["priority"]), user_id: self.user.id)
          test_case.delete("sequence")
          _test_case = TestCase.new(test_case)
          _test_case.test_suite = self
          if _test_case.valid?
            self.test_cases << _test_case
          else
            errors << "Row #{data_row} error: #{_test_case.errors.full_messages.join(',')}"
          end
          data_row = data_row + 1
        end

        if errors.present?
          self.errors.add(:base, errors)
          throw :abort
        end
      end
    end
end
