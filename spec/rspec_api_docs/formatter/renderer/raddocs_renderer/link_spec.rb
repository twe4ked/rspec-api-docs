require 'rspec_api_docs/formatter/renderer/raddocs_renderer/link'

module RspecApiDocs
  module Renderer
    class RaddocsRenderer
      RSpec.describe Link do
        describe '.call' do
          it 'returns a cleaned link' do
            example = double :example, name: 'Returns a Character'
            expect(Link.('Other Characters', example))
              .to eq 'other_characters/returns_a_character.json'
          end
        end
      end
    end
  end
end
