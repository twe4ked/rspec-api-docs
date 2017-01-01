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
          recursive_format_hash ResourceSerializer.new(resource).to_h
        end
      end

      def recursive_format_hash(hash)
        case hash
        when Hash
          Hash[
            hash.map do |key, v|
              [
                key.is_a?(Symbol) && key =~ /\A[a-z]/ ? lower_camel_case(key.to_s).to_sym : key,
                recursive_format_hash(v),
              ]
            end
          ]
        when Enumerable
          hash.map { |value| recursive_format_hash(value) }
        else
          hash
        end
      end

      def lower_camel_case(string)
        string = string.split('_').collect(&:capitalize).join
        string[0].downcase + string[1..-1]
      end

      def output_file
        Pathname.new(RspecApiDocs.configuration.output_dir) + 'index.json'
      end
    end
  end
end
