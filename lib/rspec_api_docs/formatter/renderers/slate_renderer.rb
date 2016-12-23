module RspecApiDocs
  class SlateRenderer
    attr_reader :resources

    def initialize(resources)
      @resources = resources.group_by(&:name)
    end

    def render
      FileUtils.mkdir_p output_file.dirname

      File.open(output_file, 'w') do |f|
        f.write ERB.new(File.read(template), nil, '-').result(binding)
      end
    end

    private

    def output_file
      Pathname.new(RspecApiDocs.configuration.output_dir) + 'index.html.md'
    end

    def template
      File.expand_path('../slate_renderer/slate_index.html.md.erb', __FILE__)
    end
  end
end
