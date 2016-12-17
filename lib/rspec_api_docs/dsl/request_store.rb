module RspecApiDocs
  module Dsl
    class RequestStore
      attr_reader :metadata

      def initialize(example)
        @metadata = example.metadata
      end

      def <<(value)
        metadata[METADATA_NAMESPACE][:requests] ||= []
        metadata[METADATA_NAMESPACE][:requests] << value.sort_by { |v| v.class.name }.reverse
      end
    end
  end
end
