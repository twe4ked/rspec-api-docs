require 'rspec_api_docs/formatter/resource/example'
require 'rspec_api_docs/formatter/resource/parameter'
require 'rspec_api_docs/formatter/resource/response_field'

module RspecApiDocs
  class Resource
    MAX_PRECEDENCE = 9_999

    attr_reader :rspec_example

    def initialize(rspec_example)
      @rspec_example = rspec_example
      @examples = []
    end

    # The name of the resource.
    #
    # E.g. "Characters"
    #
    # @return [String]
    def name
      metadata.fetch(:resource_name) { rspec_example.metadata[:example_group][:description] }
    end

    # The description of the resource.
    #
    # E.g. "Orders can be created, viewed, and deleted"
    #
    # @return [String]
    def description
      metadata[:resource_description]
    end

    # Returns an array of {Example}s
    #
    # @return [Array<Example>]
    def examples
      @examples.sort_by { |example| [example.precedence, example.name] }
    end

    # Add an example
    #
    # @return [void]
    def add_example(example)
      @examples << example
    end

    # @return [Integer]
    def precedence
      @precedence ||= metadata.fetch(:resource_precedence, MAX_PRECEDENCE)
    end

    # Set the resource precedence
    #
    # @return [void]
    def precedence=(value)
      @precedence = value
    end

    def inspect
      "#<RspecApiDocs::Resource #{name.inspect}, @examples=#{examples.inspect}>"
    end

    private

    def metadata
      rspec_example.metadata[METADATA_NAMESPACE]
    end
  end
end
