require 'rspec_api_docs/after/type_checker'

module RspecApiDocs
  module After
    RSpec.describe TypeChecker do
      describe '.call' do
        def call(value)
          TypeChecker.call type: type, value: value
        end

        context 'with an "integer" type' do
          let(:type) { 'integer' }

          it 'raises an error if the value is not an integer' do
            expect { call 'foo' }
              .to raise_error TypeChecker::TypeError, 'wrong type "foo", expected "integer"'
          end

          it 'does not raise an error if the value is an integer' do
            expect { call '42' }.to_not raise_error
          end
        end

        context 'with a "float" type' do
          let(:type) { 'float' }

          it 'raises an error if the value is not an float' do
            expect { call 'foo' }
              .to raise_error TypeChecker::TypeError, 'wrong type "foo", expected "float"'
          end

          it 'does not raise an error if the value is a float' do
            expect { call '4.2' }.to_not raise_error
          end
        end

        context 'with a "boolean" type' do
          let(:type) { 'boolean' }

          it 'raises an error if the value is not an boolean' do
            expect { call 'foo' }
              .to raise_error TypeChecker::TypeError, 'wrong type "foo", expected "boolean"'
          end

          it 'does not raise an error if the value is a boolean' do
            expect { call 'true' }.to_not raise_error
            expect { call 'false' }.to_not raise_error
          end
        end

        context 'with a "string" type' do
          let(:type) { 'string' }

          it 'does not raise an error if the value is a string' do
            expect { call '42' }.to_not raise_error
            expect { call '4.2' }.to_not raise_error
            expect { call 'foo' }.to_not raise_error
            expect { call 'false' }.to_not raise_error
          end
        end

        context 'with an unknown type' do
          let(:type) { 'foo' }

          it 'raises an error if the value is not an boolean' do
            expect { call 'bar' }
              .to raise_error TypeChecker::UnknownType, 'unknown type "foo"'
          end
        end
      end
    end
  end
end
