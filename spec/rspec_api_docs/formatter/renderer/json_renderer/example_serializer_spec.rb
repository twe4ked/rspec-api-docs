require 'rspec_api_docs/formatter/renderer/json_renderer/example_serializer'
require 'rspec_api_docs/formatter/resource/example'

module RspecApiDocs
  module Renderer
    class JSONRenderer
      RSpec.describe ExampleSerializer do
        describe '#to_h' do
          let(:example) do
            instance_double Resource::Example,
              description: 'Example description',
              name: 'Example name',
              http_method: 'GET',
              parameters: [],
              path: '/characters',
              requests: [],
              response_fields: []
          end

          it 'returns a hash' do
            expect(ExampleSerializer.new(example).to_h).to eq(
              description: 'Example description',
              name: 'Example name',
              httpMethod: 'GET',
              parameters: [],
              path: '/characters',
              requests: [],
              responseFields: [],
            )
          end
        end
      end
    end
  end
end
