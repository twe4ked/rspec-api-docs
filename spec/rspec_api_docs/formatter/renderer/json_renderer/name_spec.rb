require 'rspec_api_docs/formatter/renderer/json_renderer/name'

module RspecApiDocs
  module Renderer
    class JSONRenderer
      RSpec.describe Name do
        describe '.call' do
          context 'with the name "foo"' do
            subject(:name) { Name.call(name: 'foo', scope: scope) }

            context 'and no scope' do
              let(:scope) { }

              it { is_expected.to eq 'foo' }
            end

            context 'and a single scope' do
              let(:scope) { :bar }

              it { is_expected.to eq 'bar[foo]' }
            end

            context 'and multiple scopes' do
              let(:scope) { [:bar, :baz] }

              it { is_expected.to eq 'bar[baz][foo]' }
            end
          end
        end
      end
    end
  end
end
