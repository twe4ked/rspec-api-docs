require 'rake'
require 'rspec'
require 'json'
require 'rspec_api_docs/config'

module RspecApiDocs
  class RakeTask < ::Rake::TaskLib
    module RSpecMatchers
      extend RSpec::Matchers
    end

    attr_accessor \
      :verbose,
      :pattern,
      :rspec_opts,
      :existing_file,
      :dir,
      :verify

    def initialize(name = nil, &block)
      @name = name
      @verbose = true
      @pattern = 'spec/requests/**/*_spec.rb'
      @rspec_opts = []
      @existing_file = 'docs/index.json'
      @verify = false

      block.call(self) if block

      define
    end

    private

    def define
      desc default_desc
      task name do
        @dir = Dir.mktmpdir if verify

        rspec_task.run_task(verbose)

        verify! if verify
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
        task.rspec_opts = task_rspec_opts
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

    def verify!
      configure_rspec

      RSpecMatchers.expect(generated).to RSpecMatchers.eq(existing)

      remove_dir
    end

    def task_rspec_opts
      arr = rspec_opts + [
        '--format RspecApiDocs::Formatter',
        '--order defined',
      ]
      arr += ["--require #{spec_helper.path}"] if verify
      arr
    end

    def name
      @name ||
        verify ? :'docs:ensure_updated' : :'docs:generate'
    end

    def default_desc
      verify ? 'Ensure API docs are up to date' : 'Generate API docs'
    end
  end
end
