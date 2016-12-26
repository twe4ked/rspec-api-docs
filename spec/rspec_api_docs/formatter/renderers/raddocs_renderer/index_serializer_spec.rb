require 'rspec_api_docs/formatter/renderers/raddocs_renderer/index_serializer'

module RspecApiDocs
  class RaddocsRenderer
    RSpec.describe IndexSerializer do
      describe '#to_h' do
        let(:_example) do
          double :example,
            metadata: {
              METADATA_NAMESPACE => {
                requests: [
                  [double(request_method: 'GET', path: '/characters/:id')]
                ]
              },
              example_group: {description: 'Character'}
            },
            description: 'Viewing a character'
        end
        let(:resources) { [Resource.new(_example)] }
        let(:index_serializer) { IndexSerializer.new(resources) }

        it 'includes a link' do
          expect(index_serializer.to_h[:resources].first[:examples].first[:link])
            .to eq 'character/viewing_a_character.json'
        end
      end
    end
  end
end
