module RspecApiDocs
  module Renderer
    class RaddocsRenderer
      class ResourceSerializer
        attr_reader :resource

        def initialize(resource)
          @resource = resource
        end

        def to_h
          {
            resource: resource.name,
            resource_explanation: nil,
            http_method: resource.example.http_method,
            route: resource.example.path,
            description: resource.example.name,
            explanation: resource.example.description,
            parameters: parameters(resource.example.parameters),
            response_fields: response_fields(resource.example.response_fields),
            requests: requests,
          }
        end

        private

        def requests
          resource.example.requests.map { |request| request.merge(curl: nil) }
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
