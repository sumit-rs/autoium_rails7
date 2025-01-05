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
    return unless self.file.present?

    _image_type = %('image/jpeg image/png')
    if self.file.is_a?(ActionDispatch::Http::UploadedFile) and !self.file.content_type.in?(_image_type)
      errors.add(:file, "needs to be a jpeg or png!")
    elsif self.file.is_a?(String) and self.file.match(%r{\Adata:(.+?);base64,(.+)\z})
      content_type = Regexp.last_match(1)
      errors.add(:file, "needs to be a jpeg or png!") unless content_type.in?(_image_type)
    end
  end

  def file_size_limit
    return unless self.file.present?

    max_size = 5.megabytes
    if self.file.is_a?(ActionDispatch::Http::UploadedFile) and self.file.size > max_size
      errors.add(:file, "is too large. Maximum size is 5 MB.") if self.file.size > max_size
    elsif self.file.is_a?(String) and self.file.match(%r{\Adata:(.+?);base64,(.+)\z})
      encoded_data = Regexp.last_match(2)
      decoded_data = Base64.decode64(encoded_data)
      size_in_bytes = decoded_data.bytesize
      errors.add(:file, "is too large. Maximum size is 5 MB.") if size_in_bytes > max_size
    end
  end

  def upload_file_screenshot
    return unless self.file.present?
    if self.file.is_a?(ActionDispatch::Http::UploadedFile)
      self.upload_screenshot(self.file)
    elsif self.file.is_a?(String) && self.file.match(%r{\Adata:(.+?);base64,(.+)\z})
      encoded_data = Regexp.last_match(2)
      decoded_data = Base64.decode64(encoded_data)
      self.upload_screenshot(decoded_data, 'BASE64')
    end
  end

  def upload_screenshot(file, type = 'REGULAR')
    _folder_path = 'screenshots'
    environment = self.test_suite.environment
    project = environment.project

    self.remove_screenshot #first delete old file from location

    file_name = "#{SecureRandom.uuid.gsub('-', '')}.png"
    if type == 'BASE64'
      FileUploader.upload_base64(file, project.id, environment.id, _folder_path, file_name)
    else
      FileUploader.upload(file.tempfile, project.id, environment.id, _folder_path, file_name)
    end
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