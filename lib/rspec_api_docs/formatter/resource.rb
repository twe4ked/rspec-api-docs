require 'rspec_api_docs/formatter/resource/example'
require 'rspec_api_docs/formatter/resource/parameter'
require 'rspec_api_docs/formatter/resource/response_field'

module RspecApiDocs
  class Resource
    attr_reader :rspec_example

    # Returns an array of {Example}s
    #
    # @return [Array<Example>]
    attr_accessor :examples

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
      metadata.fetch(:resource_name, rspec_example.metadata[:example_group][:description])
    end

    # The description of the resource.
    #
    # E.g. "Orders can be created, viewed, and deleted"
    #
    # @return [String]
    def description
      metadata[:resource_description]
    end

    private

    def metadata
      rspec_example.metadata[METADATA_NAMESPACE]
    end
  end
end
