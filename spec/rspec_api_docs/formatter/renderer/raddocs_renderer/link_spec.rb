require 'rspec_api_docs/formatter/renderer/raddocs_renderer/link'

module RspecApiDocs
  module Renderer
    class RaddocsRenderer
      RSpec.describe Link do
        describe '.call' do
          it 'returns a cleaned link' do
            expect(Link.('Other Characters', 'Returns a Character'))
              .to eq 'other_characters/returns_a_character.json'
          end
        end
      end
    end
  end
end
