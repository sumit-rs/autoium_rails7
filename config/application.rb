require_relative "boot"

require "rails/all"

require "active_storage/engine"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FeedBook
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: 'smtp.office365.com',
      port: '587',
      authentication: :login,
      user_name: ENV["SMTP_TECH_SUPPORT_USER_NAME"],
      password: ENV["SMTP_TECH_SUPPORT_PASSWORD"],
      domain: 'resourcestack.com.com',
      enable_starttls_auto: true
    }

    config.middleware.use ExceptionNotification::Rack, email: {
      email_prefix: "[Exception][#{Rails.env.capitalize}][#{ENV["APP_NAME"]}]",
      sender_address: "TechnicalSupport <technicalsupport@resourcestack.com>",
      exception_recipients: %w[sumit.kumar@resourcestack.com],
    }

    #we was facing issue to precompile assets in production
    # https://stackoverflow.com/questions/70401077/rails-7-asset-pipeline-sasscsyntaxerror-with-tailwind/70665740#70665740
    config.assets.css_compressor = nil

    config.tinymce.install = :compile

    config.active_record.encryption.support_unencrypted_data = true
    config.active_record.encryption.extend_queries = true
    config.active_record.encryption.primary_key = ENV['ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY']
    config.active_record.encryption.deterministic_key = ENV['ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY']
    config.active_record.encryption.key_derivation_salt = ENV['ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT']

    # config.hosts << ENV["SITE_URL"] if ENV["SITE_URL"]
    # config.hosts << "www.#{ENV["SITE_URL"]}"
    config.action_mailer.default_url_options = { host: ENV["HOST"] }
  end
end
