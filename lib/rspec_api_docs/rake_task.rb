require 'pry'
require 'rake'
require 'rspec'
require 'json'
require 'rspec_api_docs/config'

module RspecApiDocs
  class RakeTask < ::Rake::TaskLib
    module RSpecMatchers
      extend RSpec::Matchers
    end

    attr_reader :name

    attr_accessor \
      :verbose,
      :pattern,
      :rspec_opts,
      :existing_file,
      :dir

    def initialize(name = nil, &block)
      @name = name || :'docs:ensure_updated'
      @verbose = true
      @pattern = 'spec/requests/**/*_spec.rb'
      @rspec_opts = []
      @existing_file = 'docs/index.json'

      block.call(self)

      define
    end

    private

    def define
      desc 'Ensure API docs are up to date'
      task name do
        @dir = Dir.mktmpdir

        rspec_task.run_task(verbose)

        configure_rspec

        RSpecMatchers.expect(generated).to RSpecMatchers.eq(existing)

        remove_dir
      end
    end

    def generated
      JSON.parse(File.read(Pathname.new(dir) + 'index.json'))
    end

    def existing
      JSON.parse(File.read(existing_file))
    end

    def rspec_task
      RSpec::Core::RakeTask.new.tap do |task|
        task.pattern = pattern
        task.rspec_opts = rspec_opts + [
          '--format RspecApiDocs::Formatter',
          '--order defined',
          "--require #{spec_helper.path}",
        ]
      end
    end

    def spec_helper
      tempfile = Tempfile.new(['shoebox', '.rb'])
      tempfile.write <<-EOF
        RspecApiDocs.configure do |config|
          config.output_dir = '#{dir}'
        end
      EOF
      tempfile.close
      tempfile
    end

    def configure_rspec
      RSpec.configure do |config|
        config.color = true
      end
    end

    def remove_dir
      FileUtils.remove_entry dir
    end
  end
end
