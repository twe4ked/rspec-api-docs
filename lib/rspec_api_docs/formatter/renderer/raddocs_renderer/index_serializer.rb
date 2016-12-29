require 'rspec_api_docs/formatter/renderer/raddocs_renderer/link'
require 'rspec_api_docs/formatter/resource'

module RspecApiDocs
  module Renderer
    class RaddocsRenderer
      class IndexSerializer
        class ExampleSerializer
          attr_reader :example, :resource_name

          def initialize(example, resource_name)
            @example = example
            @resource_name = resource_name
          end

          def to_h
            {
              description: example.name,
              link: link,
              groups: groups,
              route: example.path,
              method: example.http_method.downcase,
            }
          end

          private

          def link
            Link.(resource_name, example)
          end

          def groups
            'all'
          end
        end

        attr_reader :resources

        def initialize(resources)
          @resources = resources
        end

        def to_h
          {
            resources: resources.map do |resource|
              {
                name: resource.name,
                explanation: nil,
                examples: resource.examples.map { |example| ExampleSerializer.new(example, resource.name).to_h },
              }
            end,
          }
        end
      end
    end
  end
end
