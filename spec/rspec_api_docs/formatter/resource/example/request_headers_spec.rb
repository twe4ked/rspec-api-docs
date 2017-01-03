require 'rspec_api_docs/formatter/resource/example/request_headers'

module RspecApiDocs
  class Resource
    class Example
      RSpec.describe RequestHeaders do
        describe '.call' do
          let(:env) do
            {
              'HTTP_AUTHORIZATION' => 'Basic foo',
              'HTTP_ACCEPT' => 'application/json',
            }
          end

          it 'returns the formatted headers' do
            expect(RequestHeaders.call(env)).to eq(
              'Authorization' => 'Basic foo',
              'Accept' => 'application/json',
            )
          end

          context 'with an excluded header' do
            before do
              allow(RspecApiDocs).to receive(:configuration)
                .and_return(double(exclude_request_headers: %w[Authorization]))
            end

            it 'excludes the header' do
              expect(RequestHeaders.call(env)).to eq('Accept' => 'application/json')
            end
          end
        end
      end
    end
  end
end
