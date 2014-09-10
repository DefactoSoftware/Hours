require "simplecov"
SimpleCov.start "rails"

ENV["RAILS_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "webmock/rspec"
require "email_spec"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

module Features
  # Extend this module in spec/support/features/*.rb
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.fail_fast = true
  config.include Features, type: :feature
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.order = "random"
  config.use_transactional_fixtures = false
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers

  config.after(:each) do
    Apartment::Tenant.reset
    drop_schemas
    reset_mailer
  end
end

def drop_schemas
  connection = ActiveRecord::Base.connection.raw_connection
  schemas = connection.query("
    SELECT 'drop schema ' || nspname || ' cascade;'
    FROM pg_namespace
    WHERE nspname != 'public'
    AND nspname NOT LIKE 'pg_%'
    AND nspname != 'information_schema';
  ")

  schemas.each do |schema|
    connection.query(schema.values.first)
  end
end

Capybara.javascript_driver = :webkit
Capybara.app_host = "http://hours.dev"
WebMock.disable_net_connect!(allow_localhost: true)
