module RspecApiDocs
  class Resource
    class Parameter
      attr_reader :name, :parameter

      def initialize(name, parameter)
        @name = name
        @parameter = parameter
      end

      # The scope of the parameter
      #
      # @return [Array<String>]
      def scope
        parameter[:scope]
      end

      # If the parameter is required
      #
      # @return [String]
      def required
        !!parameter[:required]
      end

      # The description of the parameter
      #
      # @return [String]
      def description
        parameter[:description]
      end

      # @return [true, false]
      def ==(other)
        name == other.name &&
          parameter == other.parameter
      end
    end
  end
end
