module RspecApiDocs
  module Dsl
    class DocProxy
      UnknownNoteLevel = Class.new(BaseError)

      attr_reader :metadata

      def initialize(example)
        @metadata = example.metadata
      end

      # For setting the name of the example.
      #
      # E.g. "Returns a Character"
      #
      # @return [void]
      def name(value)
        metadata[METADATA_NAMESPACE][:example_name] = value
      end

      # For setting the name of the resource.
      #
      # E.g. "Characters"
      #
      # @return [void]
      def resource_name(value)
        metadata[METADATA_NAMESPACE][:resource_name] = value
      end

      # For setting the description of the resource.
      #
      # E.g. "Orders can be created, viewed, and deleted"
      #
      # @return [void]
      def resource_description(value)
        metadata[METADATA_NAMESPACE][:resource_description] = value
      end

      # For setting the precedence of the resource
      #
      # Lower numbers will be ordered higher
      #
      # @param value [Integer] the precedence
      def resource_precedence(value)
        metadata[METADATA_NAMESPACE][:resource_precedence] = value
      end

      # For setting a description of the example.
      #
      # E.g. "Allows you to return a single character."
      #
      # @return [void]
      def description(value)
        metadata[METADATA_NAMESPACE][:description] = value
      end

      # For setting the request path of the example.
      #
      # E.g. "/characters/:id"
      #
      # @return [void]
      def path(value)
        metadata[METADATA_NAMESPACE][:path] = value
      end

      # For setting response fields of a request.
      #
      # Usage:
      #
      #     doc do
      #       field :id, 'The id of a character', scope: :character
      #       field :name, "The character's name", scope: :character
      #     end
      #
      # For a response body of:
      #
      #     {
      #       character: {
      #         id: 1,
      #         name: 'Finn The Human'
      #       }
      #     }
      #
      # @param name [Symbol] the name of the response field
      # @param description [String] a description of the response field
      # @param scope [Symbol, Array<Symbol>] how the field is scoped
      # @param type [String]
      # @param example an example value
      # @return [void]
      def field(name, description, scope: [], type: nil, example: nil)
        metadata[METADATA_NAMESPACE][:fields] ||= {}
        metadata[METADATA_NAMESPACE][:fields][{name: name, scope: scope}] = {
          description: description,
          scope: Array(scope),
          type: type,
          example: example,
        }
      end

      # For setting params of a request.
      #
      # Usage:
      #
      #     doc do
      #       param :id, 'The id of a character', required: true
      #       param :name, 'A tag on a character', scope: :tag
      #     end
      #
      # For a path of:
      #
      #     /characters/:id?tag[name]=:name
      #
      # @param name [Symbol] the name of the parameter
      # @param description [String] a description of the parameter
      # @param scope [Symbol, Array<Symbol>] how the parameter is scoped
      # @param type [String]
      # @param required [true, false] if the field is required
      # @return [void]
      def param(name, description, scope: [], type: nil, required: false)
        metadata[METADATA_NAMESPACE][:parameters] ||= {}
        metadata[METADATA_NAMESPACE][:parameters][{name: name, scope: scope}] = {
          description: description,
          scope: Array(scope),
          type: type,
          required: required,
        }
      end

      # For setting notes on an example
      #
      # @param level [Symbol] the level of the note
      # @param value [String] the note, +:success+, +:info+, +:warning+, or +:danger+
      # @return [void]
      def note(level = :info, value)
        %i[success info warning danger].include?(level) or
          raise UnknownNoteLevel, "unknown note level #{level.inspect}"
        metadata[METADATA_NAMESPACE][:note] ||= {}
        metadata[METADATA_NAMESPACE][:note][level] = value
      end

      # For setting the precedence of an example
      #
      # Lower numbers will be ordered higher
      #
      # @param value [Integer] the precedence
      def precedence(value)
        metadata[METADATA_NAMESPACE][:example_precedence] = value
      end
    end
  end
end
