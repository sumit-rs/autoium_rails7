class ResultSuite < ApplicationRecord
  # -------------------------------------------------------------
  belongs_to :results_dictionary, foreign_key: :rd_id
  belongs_to :test_suite
  belongs_to :user
  belongs_to :scheduler
  has_many :result_cases

  # -------------------------------------------------------------
  def upload_video(file)
    return { status: false, message: 'Please select a file!' } unless file.present?
    return { status: false, message: 'Invalid video format! Please upload an MP4 video!' } unless file.content_type == 'video/mp4'

    file_name = "#{SecureRandom.uuid.gsub('-', '')}.mp4"
    old_file_name = self.video_file

    environment = self.test_suite.environment
    project = environment.project
    _folder_path = 'videos'

    FileUploader.upload(file.tempfile, project.id, environment.id, _folder_path, file_name)
    self.update(video_file: file_name)

    # Delete old file if it exists
    FileUploader.delete(project.id, environment.id, _folder_path, old_file_name) if old_file_name.present?

    { status: true, message: 'Video uploaded successfully!' }
  end

  def environment_id
    TestSuite.where(id: test_suite_id).pluck(:environment_id).first
  end

  def project_id
    environment_id = self.environment_id
    Environment.where(id: environment_id).pluck(:project_id).first
  end

  def video_file_url
    @file_name = self.video_file
    return '' unless @file_name.present?

    environment = self.test_suite.environment
    project = environment.project
    FileUploader.retrieve(project.id, environment.id, 'videos', @file_name)
  end
end
