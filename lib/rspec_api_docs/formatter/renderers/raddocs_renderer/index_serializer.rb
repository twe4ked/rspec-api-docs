module RspecApiDocs
  class RaddocsRenderer
    class IndexSerializer
      class ExampleSerializer
        attr_reader :resource

        def initialize(resource)
          @resource = resource
        end

        def to_h
          {
            description: resource.example_name,
            link: link,
            groups: resource.groups,
            route: resource.path,
            method: resource.http_method.downcase,
          }
        end

        private

        def link
          "#{resource.name.downcase}/#{resource.example_name.parameterize.underscore}.json"
        end
      end

      attr_reader :resources

      def initialize(resources)
        @resources = resources.group_by(&:name)
      end

      def to_h
        {
          resources: resources.map do |name, examples|
            {
              name: name,
              explanation: nil,
              examples: examples.map { |resource| ExampleSerializer.new(resource).to_h },
            }
          end
        }
      end
    end
  end
end
