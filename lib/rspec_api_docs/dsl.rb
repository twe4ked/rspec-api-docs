require 'rspec_api_docs'
require 'rspec_api_docs/dsl/request_store'
require 'rspec_api_docs/dsl/doc_proxy'

module RspecApiDocs
  # This module is intended to be included in your RSpec specs to expose the
  # {#doc} and {#no_doc} methods.
  module Dsl
    # DSL method for use in your RSpec examples.
    #
    # Usage:
    #
    #     it 'returns a character' do
    #       doc do
    #         title 'Returns a Character'
    #         description 'Allows you to return a single character.'
    #         path '/characters/:id'
    #
    #         param :id, 'The id of a character', required: true
    #
    #         field :id, 'The id of a character', scope: :character
    #         field :name, "The character's name", scope: :character
    #       end
    #
    #       get '/characters/1'
    #     end
    #
    # For more info on the methods available in the block, see {DocProxy}.
    #
    # @return [RequestStore] an object to store request/response pairs
    def doc(&block)
      example.metadata[METADATA_NAMESPACE] ||= {}

      if block
        DocProxy.new(example).instance_eval(&block)
      end

      RequestStore.new(example)
    end

    # Clears all rspec-api-docs data for the current example.
    #
    # @return [void]
    def no_doc
      example.metadata[METADATA_NAMESPACE] = nil
    end

    private

    def example
      RSpec.current_example
    end
  end
end
