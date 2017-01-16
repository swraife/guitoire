require Rails.root.join('config/smtp')
Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
  config.active_record.dump_schema_after_migration = false
  config.middleware.use Rack::Deflater
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=31557600',
  }
  config.action_mailer.default_url_options = { :host => 'guitoire.herokuapp.com' }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.asset_host = 'https://guitoire.herokuapp.com'

  ActionMailer::Base.smtp_settings = {
    :address        => ENV['SMTP_SERVER'],
    :port           => ENV['SMTP_PORT'],
    :authentication => :plain,
    :user_name      => ENV['SMTP_USERNAME'],
    :password       => ENV['SMTP_PASSWORD'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }
  
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => ENV['S3_BUCKET_NAME'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    },
    :s3_protocol => 'https'
  }

end
Rack::Timeout.timeout = (ENV['RACK_TIMEOUT'] || 10).to_i
