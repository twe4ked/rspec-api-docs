require 'rspec_api_docs'
require 'rspec_api_docs/dsl/request_store'
require 'rspec_api_docs/dsl/doc_proxy'

module RspecApiDocs
  module Dsl
    def doc(&block)
      example.metadata[METADATA_NAMESPACE] ||= {}

      if block
        DocProxy.new(example).instance_eval(&block)
      end

      RequestStore.new(example)
    end

    def no_doc
      example.metadata[METADATA_NAMESPACE] = nil
    end

    private

    def example
      RSpec.current_example
    end
  end
end
