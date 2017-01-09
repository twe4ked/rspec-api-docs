module RspecApiDocs
  class Resource
    class ResponseField
      attr_reader :name, :field

      def initialize(name, field)
        @name = name
        @field = field
      end

      # The scope of the response field
      #
      # @return [Array<String>]
      def scope
        field[:scope]
      end

      # The type of the response field
      #
      # @return [String]
      def type
        field[:type]
      end

      # The description of the response field
      #
      # @return [String]
      def description
        field[:description]
      end

      # Example value
      def example
        field[:example]
      end

      # @return [true, false]
      def ==(other)
        name == other.name &&
          field == other.field
      end
    end
  end
end
