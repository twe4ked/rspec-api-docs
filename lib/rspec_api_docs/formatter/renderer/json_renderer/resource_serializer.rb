require 'rspec_api_docs/formatter/renderer/json_renderer/example_serializer'

module RspecApiDocs
  module Renderer
    class JSONRenderer
      class ResourceSerializer
        attr_reader :resource

        def initialize(resource)
          @resource = resource
        end

        def to_h
          {
            name: resource.name,
            description: resource.description,
            examples: examples,
          }
        end

        private

        def examples
          resource.examples.map do |example|
            ExampleSerializer.new(example).to_h
          end
        end
      end
    end
  end
end
