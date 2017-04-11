require 'rspec_api_docs/formatter'

module RspecApiDocs
  RSpec.describe Formatter do
    describe '#close' do
      it 'passes the resources to the renderer ordered by precedence then name' do
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

        renderer = double
        formatter = Formatter.new(renderer: renderer)
        formatter.instance_variable_set('@resources', {
          resource_1: resource_1,
          resource_2: resource_2,
          resource_3: resource_3,
          resource_4: resource_4,
        })

        expect(renderer).to receive(:new).with([
          resource_2,
          resource_4,
          resource_3,
          resource_1,
        ]).and_return(double.as_null_object)

        formatter.close(nil)
      end
    end
  end
end
