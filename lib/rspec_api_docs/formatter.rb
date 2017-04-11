require 'rspec/core/formatters/base_formatter'

require 'rspec_api_docs'
require 'rspec_api_docs/formatter/resource'
require 'rspec_api_docs/formatter/renderer/json_renderer'
require 'rspec_api_docs/formatter/renderer/raddocs_renderer'
require 'rspec_api_docs/formatter/renderer/slate_renderer'

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

    attr_reader :renderer, :resources

    def initialize(*args, renderer: default_renderer)
      @resources = {}
      @renderer = renderer
      super args
    end

    # Initializes and stores {Resource}s.
    #
    # @return [void]
    def example_passed(example_notification)
      rspec_example = example_notification.example
      return unless rspec_example.metadata[METADATA_NAMESPACE]
      resource = Resource.new(rspec_example)
      resources[resource.name] ||= resource
      resources[resource.name].add_example Resource::Example.new(rspec_example)
    end

    # Calls the configured renderer with the stored {Resource}s.
    #
    # @return [void]
    def close(null_notification)
      renderer.new(resources.values.sort_by { |resource| [resource.precedence, resource.name] }).render
    end

    private

    def default_renderer
      value = RspecApiDocs.configuration.renderer

      case value
      when :json
        Renderer::JSONRenderer
      when :raddocs
        Renderer::RaddocsRenderer
      when :slate
        Renderer::SlateRenderer
      when Class
        value
      else
        raise UnknownRenderer, "unknown renderer #{value.inspect}"
      end
    end
  end
end
