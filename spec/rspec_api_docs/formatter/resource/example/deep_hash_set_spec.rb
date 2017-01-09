require 'rspec_api_docs/formatter/resource/example/deep_hash_set'

module RspecApiDocs
  class Resource
    class Example
      RSpec.describe DeepHashSet do
        describe '.call' do
          let(:hash) do
            {
              foo: {
                bar: {
                  baz: 1,
                },
                qux: [
                  {foo: 1},
                  {bar: 1},
                ],
              },
            }
          end
          let(:value) { 42 }

          subject(:call) { DeepHashSet.call(hash, keys, value) }

          context 'pointing at a deeply nested hash' do
            let(:keys) { [:foo, :bar, :baz] }

            it 'changes the value' do
              expect(call).to eq(
                foo: {
                  bar: {
                    baz: 42,
                  },
                  qux: [
                    {foo: 1},
                    {bar: 1},
                  ],
                },
              )
            end
          end

          context 'pointing at a hash within an array' do
            let(:keys) { [:foo, :qux, [], :foo] }

            it 'works with an array' do
              expect(call).to eq(
                foo: {
                  bar: {
                    baz: 1,
                  },
                  qux: [
                    {foo: 42},
                    {bar: 1},
                  ],
                },
              )
            end
          end
        end
      end
    end
  end
end
