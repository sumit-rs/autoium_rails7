# frozen_string_literal: true

require 'aws-sdk-s3'

class S3File
  def self.create_bucket(s3_access_key, s3_secret_key, s3_region_name, s3_bucket_name)
    s3_client = Aws::S3::Client.new(region: s3_region_name, credentials: Aws::Credentials.new(s3_access_key, s3_secret_key))
    if bucket_exists?(s3_client, s3_bucket_name)
      puts "Bucket '#{s3_bucket_name}' already exists or is already owned by you."
    else
      s3_client.create_bucket(bucket: s3_bucket_name)
      puts "Bucket '#{s3_bucket_name}' created successfully."
    end
  rescue StandardError => e
    puts "Error creating or checking bucket: #{e.message}"
  end

  def self.bucket_exists?(s3_client, s3_bucket_name)
    s3_client.list_buckets.buckets.any? { |bucket| bucket.name == s3_bucket_name }
  rescue Aws::Errors::ServiceError
    false
  end

  def self.upload(file_path, project_id, environment_id, folder_path, file_name)
    bucket = load_s3_bucket(project_id)

    create_folder_path(bucket, environment_id, folder_path)

    s3_key = s3_key_for_file(environment_id, folder_path, file_name)
    obj = bucket.object(s3_key)
    obj.upload_file(file_path)
  end

  def self.upload_base64(binary_data, project_id, environment_id, folder_path, file_name)
    bucket = load_s3_bucket(project_id)

    create_folder_path(bucket, environment_id, folder_path)

    s3_key = s3_key_for_file(environment_id, folder_path, file_name)
    obj = bucket.object(s3_key)
    obj.put(body: binary_data)
  end

  def self.retrieve(project_id, environment_id, folder_path, file_name)
    bucket = load_s3_bucket(project_id)
    file_name = file_name.split('?').first if file_name.include?('?')
    s3_key = s3_key_for_file(environment_id, folder_path, file_name)
    obj = bucket.object(s3_key)
    obj.presigned_url(:get, expires_in: 3600) # Expires in 1 hour
  end

  def self.delete(project_id, environment_id, folder_path, file_name)
    bucket = load_s3_bucket(project_id)

    s3_key = s3_key_for_file(environment_id, folder_path, file_name)
    obj = bucket.object(s3_key)
    obj.delete
  end

  def self.load_s3_bucket(project_id)
    project = Project.find(project_id)
    #todo: we should call -'create_bucket' method here to create bucket first to upload file, but currently creating bucket first manually on aws
    s3 = Aws::S3::Resource.new(
      region: project.s3_region_name,
      credentials: Aws::Credentials.new(project.s3_access_key, project.s3_secret_key)
    )

    s3.bucket(project.s3_bucket_name)
  end

  def self.create_folder_path(bucket, environment_id, folder_path)
    folder_key = s3_key_for_folder(environment_id, folder_path)
    bucket.object(folder_key).put(body: '') unless bucket.object(folder_key).exists?
  end

  def self.s3_key_for_folder(environment_id, folder_path)
    "environment_#{environment_id}/#{folder_path}/"
  end

  def self.s3_key_for_file(environment_id, folder_path, file_name)
    "environment_#{environment_id}/#{folder_path}/#{file_name}"
  end
end
