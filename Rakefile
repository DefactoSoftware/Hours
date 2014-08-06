# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path("../config/application", __FILE__)

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
task(:default).clear
task :default => [:spec, "brakeman:run"]
