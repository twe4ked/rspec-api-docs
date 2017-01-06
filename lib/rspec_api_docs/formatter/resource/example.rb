require 'rspec_api_docs/formatter/resource/example/request_headers'

module RspecApiDocs
  class Resource
    class Example
      attr_reader :example

      def initialize(example)
        @example = example
      end

      # The name of the example.
      #
      # E.g. "Returns a Character"
      #
      # @return [String]
      def name
        metadata.fetch(:example_name, example.description)
      end

      # The description of the example.
      #
      # E.g. "For getting information about a Character."
      #
      # @return [String]
      def description
        metadata[:description]
      end

      # Parameters for the example.
      #
      # @return [Array<Parameter>]
      def parameters
        metadata.fetch(:parameters, []).map do |name, parameter|
          Parameter.new(name, parameter)
        end
      end

      # Response fields for the example.
      #
      # @return [Array<ResponseField>]
      def response_fields
        metadata.fetch(:fields, []).map do |name, field|
          ResponseField.new(name, field)
        end
      end

      # Requests stored for the example.
      #
      # @return [Array<Hash>]
      def requests # rubocop:disable Metrics/AbcSize
        request_response_pairs.map do |request, response|
          {
            request_method: request.request_method,
            request_path: request_path(request),
            request_body: request_body(request.body),
            request_headers: request_headers(request.env),
            request_query_parameters: request.params,
            request_content_type: request.content_type,
            response_status: response.status,
            response_status_text: response_status_text(response.status),
            response_body: response_body(response.body),
            response_headers: response.headers,
            response_content_type: response.content_type,
          }
        end
      end

      # Path stored on the example OR the path of first route requested.
      #
      # @return [String, nil]
      def path
        metadata.fetch(:path) do
          return if request_response_pairs.empty?
          request_response_pairs.first.first.path
        end
      end

      # The HTTP method of first route requested.
      #
      # @return [String, nil]
      def http_method
        return if request_response_pairs.empty?
        request_response_pairs.first.first.request_method
      end

      # @return [Hash<Symbol,String>, nil]
      def notes
        metadata.fetch(:note, {})
      end

      # @return [String, nil]
      def precedence
        metadata[:example_precedence]
      end

      def inspect
        "#<RspecApiDocs::Resource::Example #{name.inspect}>"
      end

      private

      def request_response_pairs
        metadata.fetch(:requests, []).reject { |pair| pair.any?(&:nil?) }
      end

      def request_headers(env)
        RequestHeaders.call(env)
      end

      def request_path(request)
        URI(request.path).tap do |uri|
          uri.query = request.query_string unless request.query_string.empty?
        end.to_s
      end

      def request_body(body)
        body = body.read
        body.empty? ? nil : body
      end

      def response_body(body)
        body.empty? ? nil : body
      end

      def response_status_text(status)
        Rack::Utils::HTTP_STATUS_CODES[status]
      end

      def metadata
        example.metadata[METADATA_NAMESPACE]
      end
    end
  end
end
