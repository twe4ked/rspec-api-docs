module RspecApiDocs
  module Renderer
    class RaddocsRenderer
      class ResourceSerializer
        attr_reader :resource, :example

        def initialize(resource, example)
          @resource = resource
          @example = example
        end

        def to_h
          {
            resource: resource.name,
            resource_explanation: nil,
            http_method: example.http_method,
            route: example.path,
            description: example.name,
            explanation: example.description,
            parameters: parameters(example.parameters),
            response_fields: response_fields(example.response_fields),
            requests: requests,
          }
        end

        private

        def requests
          example.requests.map { |request| request.merge(curl: nil) }
        end

        def parameters(parameters)
          parameters.map do |parameter|
            result = {}
            result[:required] = true if parameter.required
            result[:scope] = parameter.scope
            result = result.merge(
              name: parameter.name,
              description: parameter.description,
            )
            result
          end
        end

        def response_fields(fields)
          fields.map do |field|
            {
              scope: field.scope,
              Type: field.type,
              name: field.name,
              description: field.description,
            }
          end
        end
      end
    end
  end
end
