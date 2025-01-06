# frozen_string_literal: true

class LocalFileUploader
  def self.upload(file_path, project_id, environment_id, folder_path, file_name)
    local_dir_path = LocalFileUploader.local_dir_path(project_id, environment_id, folder_path)
    FileUtils.mkdir_p(local_dir_path) unless File.directory?(local_dir_path)

    local_file_path = File.join(local_dir_path, file_name)
    FileUtils.cp(file_path, local_file_path)
  end

  def self.upload_base64(binary_file, project_id, environment_id, folder_path, file_name)
    local_dir_path = LocalFileUploader.local_dir_path(project_id, environment_id, folder_path)
    FileUtils.mkdir_p(local_dir_path) unless File.directory?(local_dir_path)

    local_file_path = File.join(local_dir_path, file_name)
    File.open(Rails.root.join(local_file_path), "wb") do |file|
      file.write(binary_file)
    end
  end

  def self.retrieve(project_id, environment_id, folder_path, file_name)
    local_file_url = LocalFileUploader.local_file_url(project_id, environment_id, folder_path, file_name)
    "#{ENV.fetch('SITE_URL')}/#{local_file_url}"
  end

  def self.delete(project_id, environment_id, folder_path, file_name)
    local_dir_path = LocalFileUploader.local_dir_path(project_id, environment_id, folder_path)
    local_file_path = File.join(local_dir_path, file_name)
    File.delete(local_file_path) if File.exist?(local_file_path)
  end

  def self.local_file_url(project_id, environment_id, folder_path, file_name)
    #screenshot file get retrieve from public/<storage_path>
    File.join(ENV["STORAGE_PATH"], "project_#{project_id}", "environment_#{environment_id}", folder_path, file_name)
  end

  def self.local_dir_path(project_id, environment_id, folder_path)
    local_dir_path = Rails.root.join('public',ENV["STORAGE_PATH"], "project_#{project_id}", "environment_#{environment_id}", folder_path)
    FileUtils.mkdir_p(local_dir_path) unless File.directory?(local_dir_path)
    local_dir_path
  end
end
