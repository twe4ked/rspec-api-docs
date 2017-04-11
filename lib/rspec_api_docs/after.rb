# TODO: Move Resource out of formatter dir
require 'rspec_api_docs/formatter/resource'
require 'rspec_api_docs/after/type_checker'

module RspecApiDocs
  UndocumentedParameter = Class.new(BaseError)

  module After
    Hook = -> (example) do
      metadata = example.metadata[METADATA_NAMESPACE]
      return unless metadata

      metadata[:requests] ||= []
      metadata[:requests] << [last_request, last_response]

      return unless RspecApiDocs.configuration.validate_params

      metadata[:requests].each do |request, response|
        request.params.each do |key, value|
          parameter = RspecApiDocs::Resource::Example.new(example).parameters
            .select { |parameter| parameter.name == key.to_sym }.first

          if parameter
            After::TypeChecker.call(type: parameter.type, value: value)
          else
            raise UndocumentedParameter, "undocumented parameter included in request #{key.inspect}"
          end
        end
      end
    end
  end
end
