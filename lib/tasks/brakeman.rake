namespace :brakeman do

  desc "Run Brakeman"
  task :run do |t|
    require "brakeman"

    Brakeman.run :app_path => ".", :print_report => true
  end
end
