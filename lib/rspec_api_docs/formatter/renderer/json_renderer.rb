require 'json'
require 'rspec_api_docs/formatter/renderer/json_renderer/name'

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
        Hash[resources.map do |resource|
          [
            resource.name,
            resource.examples.map do |example|
              {
                description: example.description,
                resourceDescription: resource.description,
                name: example.name,
                httpMethod: example.http_method,
                parameters: parameters(example.parameters),
                path: example.path,
                requests: example.requests,
                responseFields: response_fields(example.response_fields),
              }
            end
          ]
        end]
      end

      def parameters(parameters)
        parameters.map do |parameter|
          {
            name: Name.(name: parameter.name, scope: parameter.scope),
            description: parameter.description,
            required: parameter.required,
          }
        end
      end

      def response_fields(fields)
        fields.map do |field|
          {
            name: Name.(name: field.name, scope: field.scope),
            description: field.description,
            type: field.type,
          }
        end
      end

      def output_file
        Pathname.new(RspecApiDocs.configuration.output_dir) + 'index.json'
      end
    end
  end
end
