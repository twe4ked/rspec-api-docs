require 'json'
require 'rspec_api_docs/formatter/renderer/json_renderer/name'
require 'rspec_api_docs/formatter/renderer/json_renderer/resource_serializer'

module RspecApiDocs
  module Renderer
    class JSONRenderer
      attr_reader :resources

      def initialize(resources)
        @resources = resources
      end

      def render
        FileUtils.mkdir_p output_file.dirname

        File.open(output_file, 'w') do |f|
          f.write JSON.pretty_generate(output) + "\n"
        end
      end

      private

      def output
        resources.map do |resource|
          ResourceSerializer.new(resource).to_h
        end
      end

      def output_file
        Pathname.new(RspecApiDocs.configuration.output_dir) + 'index.json'
      end
    end
  end
end
