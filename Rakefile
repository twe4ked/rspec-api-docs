require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:integration_json) do |t|
  t.pattern = 'spec/integration/*_spec.rb'
  t.rspec_opts = ['--format RspecApiDocs::Formatter --require ./spec/integration/json_helper.rb']
end

desc 'Generate docs from integration specs'
task generate_integration_docs: [:integration_json]

RSpec::Core::RakeTask.new(:spec)

task default: :spec
