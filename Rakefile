require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new :rspec do |task|
  task.verbose = false
end

RuboCop::RakeTask.new :rubocop do |task|
  task.verbose = false
end

task default: [:rspec, :rubocop]
