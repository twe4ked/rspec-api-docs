require 'rspec_api_docs/formatter'

module RspecApiDocs
  RSpec.describe ResourceCollection do
    describe '#all' do
      let(:resource_1) { new_resource(resource_name: 'Xyz') }
      let(:resource_2) { new_resource(resource_name: 'Xyz', resource_precedence: 1) }
      let(:resource_3) { new_resource(resource_name: 'Abc') }
      let(:resource_4) { new_resource(resource_name: 'Abc', resource_precedence: 10) }

      it 'returns resources ordered by precedence then name' do
        collection = ResourceCollection.new(
          resource_1: resource_1,
          resource_2: resource_2,
          resource_3: resource_3,
          resource_4: resource_4,
        )

        expect(collection.all).to eq [
          resource_2,
          resource_4,
          resource_3,
          resource_1,
        ]
      end

      def new_resource(args)
        Resource.new(
          double(metadata: {
            METADATA_NAMESPACE => args,
          }),
        )
      end
    end

    describe '#add_example' do
      it 'stores the resource and example' do
        collection = ResourceCollection.new

        rspec_example = double :rspec_example

        resource = instance_double Resource, name: 'foo'
        expect(Resource).to receive(:new).with(rspec_example).and_return(resource)

        _example = instance_double Resource::Example
        expect(Resource::Example).to receive(:new).with(rspec_example).and_return(_example)

        expect(resource).to receive(:add_example).with(_example)

        collection.add_example(rspec_example)
      end

      it 'maintains the lowest precedence' do
        collection = ResourceCollection.new

        rspec_example_1 = double metadata: {
          METADATA_NAMESPACE => {
            resource_name: 'foo',
          },
        }
        collection.add_example(rspec_example_1)

        rspec_example_1 = double metadata: {
          METADATA_NAMESPACE => {
            resource_name: 'foo',
            resource_precedence: 10,
          },
        }
        collection.add_example(rspec_example_1)

        expect(collection.all.map(&:name)).to eq ['foo']
        expect(collection.all.map(&:precedence)).to eq [10]
      end
    end
  end
end
