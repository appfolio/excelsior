Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Tell Action Mailer not to deliver emails to the real world.
  # The :file delivery method writes to tmp/mails
  # See: https://github.com/rails/rails/blob/8030cff808657faa44828de001cd3b80364597de/actionmailer/lib/action_mailer/delivery_methods.rb#L29
  config.action_mailer.delivery_method = :file
  config.action_mailer.default_url_options = { :host => 'localhost:5000' }
  Rails.application.routes.default_url_options[:host] = 'localhost:5000'

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # For Sendgrid email sending
  # config.action_mailer.default_url_options = { :host => 'localhost:5000' }
  # config.action_mailer.smtp_settings = {
  #     :port =>           '587',
  #     :address =>        'smtp.sendgrid.net',
  #     :user_name =>      ENV['SENDGRID_USERNAME'],
  #     :password =>       ENV['SENDGRID_PASSWORD'],
  #     :domain =>         ENV['SENDGRID_DOMAIN'],
  #     :authentication => :plain
  # }
  # config.action_mailer.delivery_method = :smtp

  # For MailCatcher
  # Rails.application.routes.default_url_options[:host] = ENV["HOST"]
  # config.action_mailer.default_url_options = { :host => ENV["HOST"] }
  # config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = { :address => "127.0.0.1", :port => 1025 }
  # config.action_mailer.perform_deliveries = true

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
