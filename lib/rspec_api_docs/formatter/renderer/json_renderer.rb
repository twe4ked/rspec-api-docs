require 'json'
require 'rspec_api_docs/formatter/renderer/json_renderer/name'

module RspecApiDocs
  module Renderer
    class JSONRenderer
      attr_reader :resources_grouped_by_name

      def initialize(resources)
        @resources_grouped_by_name = resources.group_by(&:name)
      end

      def render
        FileUtils.mkdir_p output_file.dirname

        File.open(output_file, 'w') do |f|
          f.write JSON.pretty_generate(output) + "\n"
        end
      end

      private

      def output
        Hash[resources_grouped_by_name.map do |name, resources|
          [
            name,
            resources.map do |resource|
              {
                description: resource.description,
                resourceDescription: resource.resource_description,
                name: resource.example_name,
                httpMethod: resource.http_method,
                parameters: parameters(resource.parameters),
                path: resource.path,
                requests: resource.requests,
                responseFields: response_fields(resource.response_fields),
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
