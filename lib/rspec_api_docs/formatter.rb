require 'rspec/core/formatters/base_formatter'

require 'rspec_api_docs'
require 'rspec_api_docs/formatter/resource'
require 'rspec_api_docs/formatter/renderers/json_renderer'
require 'rspec_api_docs/formatter/renderers/raddocs_renderer'
require 'rspec_api_docs/formatter/renderers/slate_renderer'

module RspecApiDocs
  # Unknown renderer configured.
  UnknownRenderer = Class.new(BaseError)

  # The RSpec formatter.
  #
  # Usage:
  #
  #     rspec --format=RspecApiDocs::Formatter
  class Formatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :example_passed, :close

    attr_reader :resources

    def initialize(*args)
      @resources = []
      super args
    end

    # Initializes and stores {Resource}s.
    #
    # @return [void]
    def example_passed(example_notification)
      return unless example_notification.example.metadata[METADATA_NAMESPACE]
      resources << Resource.new(example_notification.example)
    end

    # Calls the configured renderer with the stored {Resource}s.
    #
    # @return [void]
    def close(null_notification)
      renderer.new(resources).render
    end

    private

    def renderer
      value = RspecApiDocs.configuration.renderer

      case value
      when :json
        JSONRenderer
      when :raddocs
        RaddocsRenderer
      when :slate
        SlateRenderer
      when Class
        value
      else
        raise UnknownRenderer, "unknown renderer #{value.inspect}"
      end
    end
  end
end
