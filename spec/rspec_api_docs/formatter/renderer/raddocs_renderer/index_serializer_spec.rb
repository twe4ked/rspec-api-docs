require 'rspec_api_docs/formatter/renderer/raddocs_renderer/index_serializer'

module RspecApiDocs
  module Renderer
    class RaddocsRenderer
      RSpec.describe IndexSerializer do
        describe '#to_h' do
          let(:rspec_example) do
            double :rspec_example,
              metadata: {
                METADATA_NAMESPACE => {
                  requests: [
                    [double(request_method: 'GET', path: '/characters/:id')]
                  ]
                },
                example_group: {description: 'Character'},
              },
              description: 'Viewing a character'
          end
          let(:resource) { Resource.new(rspec_example) }
          let(:index_serializer) { IndexSerializer.new([resource]) }

          before do
            resource.examples << Resource::Example.new(rspec_example)
          end

          it 'includes a link' do
            expect(index_serializer.to_h[:resources].first[:examples].first[:link])
              .to eq 'character/viewing_a_character.json'
          end
        end
      end
    end
  end
end
