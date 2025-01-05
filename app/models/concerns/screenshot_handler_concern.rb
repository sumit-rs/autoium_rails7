module ScreenshotHandlerConcern
  extend ActiveSupport::Concern

  included do
    attr_accessor :file

    validate :file_format, if: proc { |record| record.file.present? }
    validate :file_size_limit, if: proc { |record| record.file.present? }

    after_save :upload_file_screenshot
  end

  # -------------------------------------------------------------
  def file_format
    if !self.file.content_type.in?(%('image/jpeg image/png'))
      errors.add(:file, "needs to be a jpeg or png!")
    end
  end

  def file_size_limit
    max_size = 5.megabytes
    errors.add(:file, "is too large. Maximum size is 5 MB.") if self.file.size > max_size
  end

  def upload_file_screenshot
    return unless self.file.present?
    self.upload_screenshot(self.file)
  end
  def upload_screenshot(file)
    _folder_path = 'screenshots'
    environment = self.test_suite.environment
    project = environment.project

    self.remove_screenshot #first delete old file from location

    file_name = "#{SecureRandom.uuid.gsub('-', '')}.png"
    FileUploader.upload(file.tempfile, project.id, environment.id, _folder_path, file_name)
    self.update_columns(screenshot_file_location: file_name)

    file_name
  end

  def get_screenshot_url
    return '' unless self.screenshot_file_location.present?

    environment = self.test_suite.environment
    project = environment.project
    FileUploader.retrieve(project.id, environment.id, 'screenshots', self.screenshot_file_location)
  end

  def remove_screenshot
    _folder_path = 'screenshots'
    environment = self.test_suite.environment
    project = environment.project

    FileUploader.delete(project.id, environment.id, _folder_path, self.screenshot_file_location) if self.screenshot_file_location.present?
  end

end