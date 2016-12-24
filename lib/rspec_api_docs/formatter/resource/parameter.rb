module RspecApiDocs
  class Resource
    class Parameter
      attr_reader :name, :parameter

      def initialize(name, parameter)
        @name = name
        @parameter = parameter
      end

      def scope
        parameter[:scope].join
      end

      def required
        parameter[:required]
      end

      def description
        parameter[:description]
      end

      def ==(other)
        name == other.name &&
          parameter == other.parameter
      end
    end
  end
end
