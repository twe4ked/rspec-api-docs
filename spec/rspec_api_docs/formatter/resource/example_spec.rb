require 'rspec_api_docs/formatter/resource/example'
require 'json'

module RspecApiDocs
  class Resource
    RSpec.describe Example do
      let(:example_metadata) { {METADATA_NAMESPACE => _metadata} }
      let(:_example) { double :example, metadata: example_metadata }
      let(:_metadata) { {} }
      subject { Example.new(_example) }

      describe '#name' do
        let(:_example) { double :example, description: 'Viewing a character', metadata: example_metadata }

        it 'returns the example description' do
          expect(subject.name).to eq 'Viewing a character'
        end

        context 'when a custom name is set' do
          let(:_metadata) { {example_name: 'Viewing characters'} }

          it 'returns the custom name' do
            expect(subject.name).to eq 'Viewing characters'
          end
        end
      end

      describe '#description' do
        let(:_metadata) { {description: 'Characters from the Land of Ooo'} }

        it 'returns the description' do
          expect(subject.description).to eq 'Characters from the Land of Ooo'
        end
      end

      describe '#parameters' do
        it 'returns an empty array' do
          expect(subject.parameters).to eq []
        end

        context 'with parameters' do
          let(:_metadata) do
            {
              parameters: {
                {name: :id} => {
                  description: 'The character id',
                  scope: ['character'],
                  required: true,
                },
                {name: :name} => {
                  description: 'The name of character',
                  scope: ['character'],
                },
              },
            }
          end

          it 'returns the parameters' do
            expect(subject.parameters).to eq [
              Resource::Parameter.new(:id, {
                description: 'The character id',
                scope: ['character'],
                required: true,
              }),
              Resource::Parameter.new(:name, {
                description: 'The name of character',
                scope: ['character'],
              }),
            ]
          end
        end
      end

      describe '#response_fields' do
        it 'returns an empty array' do
          expect(subject.response_fields).to eq []
        end

        context 'with response_fields' do
          let(:_metadata) do
            {
              fields: {
                {name: :id} => {
                  description: 'The character id',
                  scope: ['character'],
                  type: 'integer',
                },
                {name: :name} => {
                  description: 'The name of character',
                  scope: ['character'],
                  type: 'string',
                },
              },
            }
          end

          it 'returns the response fields' do
            expect(subject.response_fields).to eq [
              Resource::ResponseField.new(:id, {
                description: 'The character id',
                scope: ['character'],
                type: 'integer',
              }),
              Resource::ResponseField.new(:name, {
                description: 'The name of character',
                scope: ['character'],
                type: 'string',
              }),
            ]
          end
        end
      end

      describe '#requests' do
        let(:context) { double :context }
        let(:_metadata) do
          {
            requests: [
              [last_request_1, last_response_1],
              [last_request_2, last_response_2],
            ],
          }
        end

        let(:request_1_body) do
          body = JSON.dump(character: {name: 'Earl of Lemongrab'})
          StringIO.new(body).tap do |io|
            io.read
          end
        end
        let(:last_request_1) do
          double(:last_request,
            request_method: 'POST',
            path: '/characters',
            body: request_1_body,
            query_string: '',
            env: {},
            params: {},
            content_type: 'application/json',
          )
        end
        let(:last_response_1_headers) { {} }
        let(:last_response_1) do
          double(:last_response,
            status: 201,
            body: JSON.dump(character: {id: 1, name: 'Earl of Lemongrab'}),
            headers: last_response_1_headers,
            content_type: 'application/json',
          )
        end

        let(:last_request_2) do
          double(:last_request,
            request_method: 'GET',
            path: '/characters/1',
            body: StringIO.new,
            query_string: '',
            env: {},
            params: {},
            content_type: 'application/json',
          )
        end
        let(:last_response_2) do
          double(:last_response,
            status: 200,
            body: JSON.dump(character: {id: 1, name: 'Princess Bubblegum'}),
            headers: {},
            content_type: 'application/json',
          )
        end

        it 'returns requests' do
          expect(subject.requests).to eq [
            {
              request_method: 'POST',
              request_path: '/characters',
              request_body: '{"character":{"name":"Earl of Lemongrab"}}',
              request_headers: {},
              request_query_parameters: {},
              request_content_type: 'application/json',
              response_status: 201,
              response_status_text: 'Created',
              response_body: '{"character":{"id":1,"name":"Earl of Lemongrab"}}',
              response_headers: {},
              response_content_type: 'application/json',
            },
            {
              request_method: 'GET',
              request_path: '/characters/1',
              request_body: nil,
              request_headers: {},
              request_query_parameters: {},
              request_content_type: 'application/json',
              response_status: 200,
              response_status_text: 'OK',
              response_body: '{"character":{"id":1,"name":"Princess Bubblegum"}}',
              response_headers: {},
              response_content_type: 'application/json',
            },
          ]
        end

        context 'when the response does not contain JSON' do
          let(:last_response_2) do
            double(:last_response,
              status: 200,
              body: 'BINARY PDF DATA',
              headers: {},
              content_type: 'application/pdf',
            )
          end

          it 'returns requests but excludes the PDF body' do
            expect(subject.requests).to eq [
              {
                request_method: 'POST',
                request_path: '/characters',
                request_body: '{"character":{"name":"Earl of Lemongrab"}}',
                request_headers: {},
                request_query_parameters: {},
                request_content_type: 'application/json',
                response_status: 201,
                response_status_text: 'Created',
                response_body: '{"character":{"id":1,"name":"Earl of Lemongrab"}}',
                response_headers: {},
                response_content_type: 'application/json',
              },
              {
                request_method: 'GET',
                request_path: '/characters/1',
                request_body: nil,
                request_headers: {},
                request_query_parameters: {},
                request_content_type: 'application/json',
                response_status: 200,
                response_status_text: 'OK',
                response_body: nil,
                response_headers: {},
                response_content_type: 'application/pdf',
              },
            ]
          end
        end

        context 'with excluded response headers' do
          let(:_metadata) do
            {
              requests: [
                [last_request_1, last_response_1],
              ],
            }
          end
          let(:last_response_1_headers) do
            {
              'Authorization' => 'Basic foo',
              'Accept' => 'application/json',
            }
          end

          it 'excludes the specified response headers' do
            allow(RspecApiDocs).to receive(:configuration)
              .and_return(double(exclude_response_headers: %w[Authorization]))

            expect(subject.requests.first[:response_headers]).to eq(
              'Accept' => 'application/json',
            )
          end
        end
      end
    end
  end
end
