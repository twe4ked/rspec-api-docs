require 'json'

require 'rspec_api_docs/formatter/renderer/raddocs_renderer/index_serializer'
require 'rspec_api_docs/formatter/renderer/raddocs_renderer/link'
require 'rspec_api_docs/formatter/renderer/raddocs_renderer/resource_serializer'

module RspecApiDocs
  module Renderer
    class RaddocsRenderer
      attr_reader :resources

      def initialize(resources)
        @resources = resources
      end

      def render
        write_index
        write_examples
      end

      private

      def write_index
        FileUtils.mkdir_p output_dir

        File.open(output_dir + 'index.json', 'w') do |f|
          f.write JSON.pretty_generate(IndexSerializer.new(resources).to_h) + "\n"
        end
      end

      def write_examples
        resources.each do |resource|
          resource.examples.each do |example|
            write_example(resource, example)
          end
        end
      end

      def write_example(resource, example)
        FileUtils.mkdir_p file(resource, example).dirname

        File.open(file(resource, example), 'w') do |f|
          f.write JSON.pretty_generate(ResourceSerializer.new(resource, example).to_h) + "\n"
        end
      end

      def output_dir
        Pathname.new RspecApiDocs.configuration.output_dir
      end

      def file(resource, example)
        output_dir + Link.(resource.name, example.name)
      end
    end
  end
end
