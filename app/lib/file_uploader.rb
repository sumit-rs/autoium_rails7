# frozen_string_literal: true

class FileUploader

  def self.upload(file_path, project_id, environment_id, folder_path, file_name)
    use_s3 = should_use_s3(project_id)
    if use_s3
      S3File.upload(file_path, project_id, environment_id, folder_path, file_name)
    else
      LocalFileUploader.upload(file_path, project_id, environment_id, folder_path, file_name)
    end
  end

  def self.retrieve(project_id, environment_id, folder_path, file_name)
    use_s3 = should_use_s3(project_id)
    if use_s3
      S3File.retrieve(project_id, environment_id, folder_path, file_name)
    else
      LocalFileUploader.retrieve(project_id, environment_id, folder_path, file_name)
    end
  end

  def self.delete(project_id, environment_id, folder_path, file_name)
    use_s3 = should_use_s3(project_id)
    if use_s3
      S3File.delete(project_id, environment_id, folder_path, file_name)
    else
      LocalFileUploader.delete(project_id, environment_id, folder_path, file_name)
    end
  end

  def self.should_use_s3(project_id)
    Project.where(id: project_id).pluck(:save_to_s3).first
  end
end