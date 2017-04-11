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

    describe '#examples' do
      let(:empty_metadata) { {METADATA_NAMESPACE => {}} }

      it 'returns examples ordered by precedence then name' do
        [
          example_1 = Resource::Example.new(
            double(metadata: empty_metadata, description: 'Xyz'),
          ),
          example_2 = Resource::Example.new(
            double(metadata: {
              METADATA_NAMESPACE => {example_precedence: 1},
            }, description: 'Xyz'),
          ),
          example_3 = Resource::Example.new(
            double(metadata: empty_metadata, description: 'Abc'),
          ),
          example_4 = Resource::Example.new(
            double(metadata: {
              METADATA_NAMESPACE => {example_precedence: 10},
            }, description: 'Abc'),
          ),
        ].each do |_example|
          resource.add_example _example
        end

        expect(resource.examples).to eq [
          example_2,
          example_4,
          example_3,
          example_1,
        ]
      end
    end
  end
end
