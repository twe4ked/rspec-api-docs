require 'rspec_api_docs/formatter/resource'
require 'json'

module RspecApiDocs
  RSpec.describe Resource do
    let(:example_metadata) { {METADATA_NAMESPACE => _metadata} }
    let(:_example) { double :example, metadata: example_metadata }
    let(:_metadata) { {} }
    let(:resource) { Resource.new(_example) }

    describe '#name' do
      let(:_example) { double :example, metadata: example_metadata.merge(example_group: {description: 'Character'}) }

      it 'returns the example group description' do
        expect(resource.name).to eq 'Character'
      end

      context 'when a custom name is set' do
        let(:_metadata) { {resource_name: 'The Characters'} }

        it 'returns the custom name' do
          expect(resource.name).to eq 'The Characters'
        end
      end
    end

    describe '#example_name' do
      let(:_example) { double :example, description: 'Viewing a character', metadata: example_metadata }

      it 'returns the example description' do
        expect(resource.example_name).to eq 'Viewing a character'
      end

      context 'when a custom name is set' do
        let(:_metadata) { {example_name: 'Viewing characters'} }

        it 'returns the custom name' do
          expect(resource.example_name).to eq 'Viewing characters'
        end
      end
    end

    describe '#description' do
      let(:_metadata) { {description: 'Characters from the Land of Ooo'} }

      it 'returns the description' do
        expect(resource.description).to eq 'Characters from the Land of Ooo'
      end
    end

    describe '#parameters' do
      it 'returns an empty array' do
        expect(resource.parameters).to eq []
      end

      context 'with parameters' do
        let(:_metadata) do
          {
            parameters: {
              id: {
                description: 'The character id',
                scope: ['character'],
                required: true,
              },
              name: {
                description: 'The name of character',
                scope: ['character'],
              },
            }
          }
        end

        it 'returns the parameters' do
          expect(resource.parameters).to eq [
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
        expect(resource.response_fields).to eq []
      end

      context 'with response_fields' do
        let(:_metadata) do
          {
            fields: {
              id: {
                description: 'The character id',
                scope: ['character'],
                type: 'integer',
              },
              name: {
                description: 'The name of character',
                scope: ['character'],
                type: 'string',
              },
            }
          }
        end

        it 'returns the response fields' do
          expect(resource.response_fields).to eq [
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
          ]
        }
      end

      let(:last_request_1) do
        double(:last_request,
          request_method: 'POST',
          path: '/characters',
          body: StringIO.new,
          query_string: '',
          env: {},
          params: {},
          content_type: 'application/json',
        )
      end
      let(:last_response_1) do
        double(:last_response,
          status: 201,
          body: JSON.dump(character: {id: 1, name: 'Earl of Lemongrab'}),
          headers: {},
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
        expect(resource.requests).to eq [
          {
            request_method: 'POST',
            request_path: '/characters',
            request_body: nil,
            request_headers: {},
            request_query_parameters: {},
            request_content_type: 'application/json',
            response_status: 201,
            response_status_text: 'Created',
            response_body: '{"character":{"id":1,"name":"Earl of Lemongrab"}}',
            response_headers: {},
            response_content_type: 'application/json',
            curl: nil,
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
            curl: nil,
          },
        ]
      end
    end

    describe '#link' do
      let(:_example) do
        double :example,
          metadata: example_metadata.merge(example_group: {description: 'Character'}),
          description: 'Viewing a character'
      end

      it 'returns a link' do
        expect(resource.link).to eq 'character/viewing_a_character.json'
      end
    end

    describe '#groups' do
      it 'returns all' do
        expect(resource.groups).to eq 'all'
      end
    end
  end
end
