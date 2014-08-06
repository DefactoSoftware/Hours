Hours::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  if ENV["CACHE_DEVELOPMENT"]
    config.action_controller.perform_caching = true
    config.cache_store = :dalli_store
  else
    config.action_controller.perform_caching = false
  end

  # Don"t care if the mailer can"t send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  # Raise an ActionController::UnpermittedParameters exception when
  # a parameter is not explcitly permitted but is passed anyway.
  config.action_controller.action_on_unpermitted_parameters = :raise

  config.action_mailer.default_url_options = { host: "hours.dev" }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    domain:               "example.com",
    user_name:            ENV["GMAIL_USERNAME"],
    password:             ENV["GMAIL_PASSWORD"],
    authentication:       "plain",
    enable_starttls_auto: true
  }
end
