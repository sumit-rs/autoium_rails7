class TestCase < ApplicationRecord

  # -------------------------------------------------------------
  SELENIUM_FIELD_TYPE = 'SELENIUM_CODE'
  DEFAULT_JAVASCRIPT_CONDITIONAL = 'function execute(){
        return true;
    }
return execute();'

  DEFAULT_CUSTOM_SELENIUM_CODE = "const { By } = require('selenium-webdriver');
    exports.executeSeleniumCodeAsync = async function (driver, resultCallBack)
    { return new Promise(function ()
        {
            //Put your code here
            resultCallBack(true, 'Successfully completed!');
        });
    }"
  # -------------------------------------------------------------

  belongs_to :user
  belongs_to :test_suite
  belongs_to :custom_command, optional: true
  has_many :test_case_overrides, dependent: :destroy
  has_one :environment, through: :test_suite

  # -------------------------------------------------------------
  attr_accessor :custom_selenium_js

  # -------------------------------------------------------------
  store :additional_info, accessors: [:parameters], coder: JSON

  # -------------------------------------------------------------
  validates :custom_selenium_js, presence: true, if: proc{|record| record.field_type == TestCase::SELENIUM_FIELD_TYPE}

  # -------------------------------------------------------------
  before_save :check_javascript_conditional
  before_save :populate_selenium_file
  # -------------------------------------------------------------

  def get_selenium_file_content
    return unless self.selenium_file.present?

    file_path = TestCase.get_file_path(self.selenium_file)
    File.exist?(file_path) ? File.read(file_path) : ''
  end
  def self.get_file_path(file_name)
    folder_name = "#{ENV['STORAGE_PATH']}/scripts/"
    Dir.mkdir folder_name unless Dir.exist? folder_name
    "#{folder_name}#{file_name}"
  end

  def self.update_selenium_file(content, file_name)
    file_path = get_file_path(file_name)
    is_file_available = (file_name.present? && File.exist?(file_path)) ? true : false

    unless is_file_available
      file_name = "#{SecureRandom.uuid}.js"
      file_path = get_file_path(file_name)
    end

    File.write(file_path, content)
    file_name
  end

  private

  def check_javascript_conditional
    self.javascript_conditional = '' if self.javascript_conditional_enabled === "0"
  end

  def populate_selenium_file
    return unless self.field_type == TestCase::SELENIUM_FIELD_TYPE
    self.selenium_file = TestCase.update_selenium_file(self.custom_selenium_js, (self.selenium_file || self.field_name))
  end
end
