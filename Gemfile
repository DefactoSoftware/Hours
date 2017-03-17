source "https://rubygems.org"

ruby "2.3.1"

gem "rollbar", "~> 2.12.0" # Unless you are using JRuby, we suggest also installing Oj for JSON serialization.
gem "oj", '~> 2.17.4'
gem "bourbon"
gem "coffee-rails"
gem "delayed_job_active_record", "4.0.3"
gem "email_validator"
gem "flutie"
gem "high_voltage"
gem "jquery-rails", "~> 4.0"
gem "neat"
gem "bitters"
gem "pg"
gem "rack-timeout"
gem "rails", "~> 4.2.5"
gem "recipient_interceptor"
gem "sass-rails", "~> 5.0.1"
gem "simple_form", "~> 3.1.0"
gem "title"
gem "uglifier"
gem "unicorn"
gem "devise", "~> 3.5.2"
gem "devise_invitable", "~> 1.5.5"
gem "apartment", "~> 0.26.0"
gem "pikaday-gem", "~> 1.2.0.0"  ### this may be probably removed
gem "momentjs-rails"
gem "gravatar_image_tag"
gem "hashtel", "~> 0.0.2"
gem "kaminari"
gem "select2-rails"
gem "http_accept_language"
gem "normalize-rails"
gem "twitter-text" # hashtag parsing
gem "jquery-atwho-rails", "~> 1.3.2" # autocomplete
gem "haml-rails"
gem "audited-activerecord", "~> 4.0"
gem "paperclip", "4.2.4"
gem "aws-sdk", "< 2.0"
gem "redcarpet"
gem "holidays"
gem "sprockets-rails", "~> 2.3"
gem "brakeman"

source "https://rails-assets.org" do
  gem "rails-assets-chartjs"
end

# caching

gem "kgio" # faster I/O
gem "dalli" # memcached
gem "memcachier"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "foreman"
  gem "pry"
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.0"
  gem "annotate"
  gem "letter_opener"
  gem "email_spec"
end

group :test do
  gem 'poltergeist', '~> 1.10.0'
  gem "database_cleaner"
  gem "launchy"
  gem "shoulda-matchers", "~> 2.7.0"
  gem "simplecov", '~> 0.9', require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rails_12factor"
end
