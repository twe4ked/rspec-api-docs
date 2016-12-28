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
  end
end
