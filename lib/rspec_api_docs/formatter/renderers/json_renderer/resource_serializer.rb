module RspecApiDocs
  class JSONRenderer
    class ResourceSerializer
      attr_reader :resource

      def initialize(resource)
        @resource = resource
      end

      def to_h
        {
          resource: resource.name,
          resource_explanation: nil,
          http_method: resource.http_method,
          route: resource.path,
          description: resource.example_name,
          explanation: resource.description,
          parameters: resource.parameters,
          response_fields: resource.response_fields,
          requests: resource.requests,
        }
      end
    end
  end
end
