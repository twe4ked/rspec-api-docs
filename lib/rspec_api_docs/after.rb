require 'rspec_api_docs/after/type_checker'

module RspecApiDocs
  UndocumentedParameter = Class.new(BaseError)

  class After
    Hook = -> (example) do
      metadata = example.metadata[METADATA_NAMESPACE]
      return unless metadata

      metadata[:requests] ||= []
      metadata[:requests] << [last_request, last_response]

      metadata[:requests].each do |request, response|
        request.params.each do |key, value|
          if metadata[:parameters].has_key?(key.to_sym)
            After::TypeChecker.call(type: metadata[:parameters][key.to_sym][:type], value: value)
          else
            raise UndocumentedParameter, "undocumented parameter included in request #{key.inspect}"
          end
        end
      end
    end
  end
end
