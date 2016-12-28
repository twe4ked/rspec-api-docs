require 'rspec_api_docs/formatter/renderer/json_renderer/resource_serializer'

module RspecApiDocs
  module Renderer
    class JSONRenderer
      RSpec.describe ResourceSerializer do
        describe '#to_h' do
          let(:resource) do
            double(:resource,
              name: 'Characters',
              description: 'All about characters',
              examples: [example],
            )
          end
          let(:example) { double :example }
          let(:serialized_example) { double :serialized_example }
          let(:example_serializer) { double :example_serializer }

          before do
            allow(ExampleSerializer).to receive(:new).with(example)
              .and_return example_serializer
            allow(example_serializer).to receive(:to_h)
              .and_return serialized_example
          end

          it 'returns a hash' do
            expect(ResourceSerializer.new(resource).to_h)
              .to eq(
                name: 'Characters',
                description: 'All about characters',
                examples: [serialized_example],
              )
          end
        end
      end
    end
  end
end
