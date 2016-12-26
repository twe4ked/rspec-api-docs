module RspecApiDocs
  module Dsl
    # Used to store request/response pairs.
    class RequestStore
      attr_reader :metadata

      def initialize(example)
        @metadata = example.metadata
      end

      # Only needed if you need to store multiple requests for a single example.
      #
      # Usage:
      #
      #     it 'stores the requests a character' do
      #       doc do
      #         explanation 'Creating and requesting a character'
      #       end
      #
      #       post '/characters', {name: 'Finn The Human'}
      #
      #       doc << [last_request, last_response]
      #
      #       get '/characters/1'
      #
      #       # The last request/response pair is stored automatically
      #     end
      #
      # @param value [Array<Rack::Request, Rack::Response>] an array of a request and response object
      # @return [void]
      def <<(value)
        metadata[METADATA_NAMESPACE][:requests] ||= []
        metadata[METADATA_NAMESPACE][:requests] << value.sort_by { |v| v.class.name }.reverse
      end
    end
  end
end
