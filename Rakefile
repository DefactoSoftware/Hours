# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path("config/application", __dir__)

Hours::Application.load_tasks
if defined?(RSpec)
  task(:spec).clear

  desc "Run all specs"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "--tag ~factory"
  end

  desc "Run factory specs."
  RSpec::Core::RakeTask.new(:factory_specs) do |t|
    t.pattern = "./spec/models/factories_spec.rb"
  end

  task spec: :factory_specs
end

namespace :brakeman do
  desc "Run Brakeman"
  task :check, :output_files do |_t, args|
    require "brakeman"

    files = args[:output_files].split(" ") if args[:output_files]
    Brakeman.run app_path: ".", output_files: files, print_report: true
  end
end

task(:default).clear
task default: [:spec, "brakeman:check"]
