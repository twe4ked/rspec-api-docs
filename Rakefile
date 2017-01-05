require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rspec_api_docs/rake_task'

RSpec::Core::RakeTask.new :rspec do |task|
  task.verbose = false
end

RuboCop::RakeTask.new :rubocop do |task|
  task.verbose = false
end

task :generate_integration_docs do
  system './bin/generate_integration_docs'
  exit $?.exitstatus
end

RspecApiDocs::RakeTask.new do |task|
  task.verbose = false
  task.rspec_opts = [
    '--require ./spec/integration/json_helper.rb',
    '--format progress',
  ]
  task.pattern = 'spec/integration/rspec_api_docs_spec.rb'
  task.existing_file = 'spec/integration/output/json/index.json'
end

task default: [:rspec, :rubocop, :generate_integration_docs]
