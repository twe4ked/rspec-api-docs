require 'rspec_api_docs/formatter'

module RspecApiDocs
  RSpec.describe ResourceCollection do
    describe '#all' do
      it 'returns resources ordered by precedence then name' do
        resource_1 = Resource.new(
          double(metadata: {METADATA_NAMESPACE => {
            resource_name: 'Xyz',
          }}),
        )
        resource_2 = Resource.new(
          double(metadata: {METADATA_NAMESPACE => {
            resource_name: 'Xyz',
            resource_precedence: 1,
          }}),
        )
        resource_3 = Resource.new(
          double(metadata: {METADATA_NAMESPACE => {
            resource_name: 'Abc',
          }}),
        )
        resource_4 = Resource.new(
          double(metadata: {METADATA_NAMESPACE => {
            resource_name: 'Abc',
            resource_precedence: 10,
          }}),
        )

        collection = ResourceCollection.new
        collection[:resource_1] = resource_1
        collection[:resource_2] = resource_2
        collection[:resource_3] = resource_3
        collection[:resource_4] = resource_4

        expect(collection.all).to eq [
          resource_2,
          resource_4,
          resource_3,
          resource_1,
        ]
      end
    end
  end
end
