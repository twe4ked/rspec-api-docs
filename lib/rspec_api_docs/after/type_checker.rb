module RspecApiDocs
  module After
    class TypeChecker
      UnknownType = Class.new(BaseError)
      TypeError = Class.new(BaseError)

      attr_reader :type, :value

      def self.call(*args)
        new(*args).check
      end

      def initialize(type:, value:)
        @type = type
        @value = value
      end

      def check
        case type
        when /integer/i
          is_integer?(value) or raise_type_error
        when /float/i
          is_float?(value) or raise_type_error
        when /boolean/i
          is_bool?(value) or raise_type_error
        when /string/i
          # NO OP
        else
          raise UnknownType, "unknown type #{type.inspect}"
        end
      end

      private

      def is_integer?(str)
        Integer(str) && true
      rescue ArgumentError
        false
      end

      def is_float?(str)
        Float(str) && true
      rescue ArgumentError
        false
      end

      def is_bool?(str)
        %w[true false].include?(str)
      end

      def raise_type_error
        raise TypeError, "wrong type #{value.inspect}, expected #{type.inspect}"
      end
    end
  end
end
