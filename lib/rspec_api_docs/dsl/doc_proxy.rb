module RspecApiDocs
  module Dsl
    class DocProxy
      attr_reader :metadata

      def initialize(example)
        @metadata = example.metadata
      end

      def name(value)
        metadata[METADATA_NAMESPACE][:example_name] = value
      end

      def resource_name(value)
        metadata[METADATA_NAMESPACE][:resource_name] = value
      end

      def description(value)
        metadata[METADATA_NAMESPACE][:description] = value
      end

      def path(value)
        metadata[METADATA_NAMESPACE][:path] = value
      end

      def field(name, description, scope: [], type: nil)
        metadata[METADATA_NAMESPACE][:fields] ||= {}
        metadata[METADATA_NAMESPACE][:fields][name] = {
          description: description,
          scope: Array(scope),
          type: type,
        }
      end

      def param(name, description, scope: [], type: nil, required: false)
        metadata[METADATA_NAMESPACE][:parameters] ||= {}
        metadata[METADATA_NAMESPACE][:parameters][name] = {
          description: description,
          scope: Array(scope),
          type: type,
          required: required,
        }
      end
    end
  end
end
