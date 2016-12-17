require 'rspec/core/formatters/base_formatter'
require 'json'

require 'rspec_api_docs/formatter/resource'
require 'rspec_api_docs/formatter/renderers/json_renderer'

module RspecApiDocs
  class Formatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :example_passed, :close

    attr_reader :resources

    def initialize(*args)
      @resources = []
      super args
    end

    def example_passed(example_notification)
      return unless example_notification.example.metadata[METADATA_NAMESPACE]
      resources << Resource.new(example_notification.example)
    end

    def close(null_notification)
      JSONRender.new(resources).render
    end
  end
end
