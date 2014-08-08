source "https://rubygems.org"

ruby "2.1.0"

gem "airbrake"
gem "bourbon"
gem "coffee-rails"
gem "delayed_job_active_record"
gem "email_validator"
gem "flutie"
gem "high_voltage"
gem "jquery-rails"
gem "neat"
gem "bitters"
gem "pg"
gem "rack-timeout"
gem "rails", "~> 4.1.4"
gem "recipient_interceptor"
gem "sass-rails", "~> 4.0.1"
gem "simple_form"
gem "title"
gem "uglifier"
gem "unicorn"
gem "devise", "~> 3.2.4"
gem "apartment", "~> 0.25.0"
gem "pikaday-gem", "~> 1.1.0.0"
gem "momentjs-rails"
gem "gravatar_image_tag"
gem "hashtel", "~> 0.0.2"
gem "chart-js-rails"
gem "kaminari"
gem "select2-rails"
gem "http_accept_language"
gem "normalize-rails"

# caching

gem "kgio" # faster I/O
gem "dalli" # memcached
gem "memcachier"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "foreman"
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails", ">= 2.14"
  gem "annotate"
  gem "brakeman"
end

group :test do
  gem "capybara-webkit", ">= 1.0.0"
  gem "database_cleaner"
  gem "launchy"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "newrelic_rpm", ">= 3.7.3"
end
