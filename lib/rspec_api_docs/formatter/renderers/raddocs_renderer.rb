require 'json'

require 'rspec_api_docs/formatter/renderers/raddocs_renderer/index_serializer'
require 'rspec_api_docs/formatter/renderers/raddocs_renderer/resource_serializer'

module RspecApiDocs
  class RaddocsRenderer
    attr_reader :resources

    def initialize(resources)
      @resources = resources
    end

    def render
      FileUtils.mkdir_p output_dir

      File.open(output_dir + 'index.json', 'w') do |f|
        f.write JSON.pretty_generate(IndexSerializer.new(resources).to_h) + "\n"
      end

      resources.each do |resource|
        FileUtils.mkdir_p output_dir + Pathname.new(link(resource)).dirname

        File.open(output_dir + link(resource), 'w') do |f|
          f.write JSON.pretty_generate(ResourceSerializer.new(resource).to_h) + "\n"
        end
      end
    end

    private

    def output_dir
      Pathname.new RspecApiDocs.configuration.output_dir
    end

    def link(resource)
      "#{resource.name.downcase}/#{resource.example_name.parameterize.underscore}.json"
    end
  end
end
