module RspecApiDocs
  module Renderer
    class JSONRenderer
      class ExampleSerializer
        attr_reader :example

        def initialize(example)
          @example = example
        end

        def to_h
          {
            description: example.description,
            name: example.name,
            httpMethod: example.http_method,
            parameters: parameters(example.parameters),
            path: example.path,
            requests: example.requests,
            responseFields: response_fields(example.response_fields),
          }
        end

        private

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
      end
    end
  end
end
