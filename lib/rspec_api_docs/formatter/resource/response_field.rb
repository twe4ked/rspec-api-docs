module RspecApiDocs
  class Resource
    class ResponseField
      attr_reader :name, :field

      def initialize(name, field)
        @name = name
        @field = field
      end

      def scope
        field[:scope].join
      end

      def type
        field[:type]
      end

      def description
        field[:description]
      end

      def ==(other)
        name == other.name &&
          field == other.field
      end
    end
  end
end
