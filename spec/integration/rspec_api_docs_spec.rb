require 'base64'
require 'rack/test'
require 'sinatra'
require 'rspec_api_docs/dsl'

RSpec.describe RspecApiDocs do
  include Rack::Test::Methods
  include RspecApiDocs::Dsl

  class TestApp < Sinatra::Base
    CHARACTERS = {
      1 => {name: 'Finn the Human'},
      2 => {name: 'Jake the Dog'},
    }

    PLACES = {
      1 => {name: 'Candy Kingdom'},
      2 => {name: 'Tree Fort'},
    }

    get '/characters' do
      characters = CHARACTERS.map { |id, character| {id: id}.merge(character) }

      JSON.dump(data: characters)
    end

    get '/characters/:id' do
      id = params[:id].to_i
      character = CHARACTERS[id]

      if character
        JSON.dump(character: {id: (10..99).to_a.sample}.merge(character))
      else
        status 404
        JSON.dump(
          errors: {
            message: 'Character not found.',
          },
        )
      end
    end

    delete '/characters/:id' do
      JSON.dump(
        message: 'Character not found.',
      )
    end

    get '/places' do
      if params[:page]
        JSON.dump(data: [])
      else
        places = PLACES.map { |id, place| {id: id}.merge(place) }

        JSON.dump(data: places)
      end
    end
  end

  def app
    TestApp
  end

  describe 'Characters' do
    before do
      doc do
        resource_name 'Characters'
        resource_description <<-EOF.gsub(/^ {10}/, '')
          Characters inhabit the Land of Ooo.

          Use the following endpoints to fetch information and modify them.
        EOF
      end
    end

    it 'returns all characters' do
      doc do
        name 'Listing all characters'
        description <<-EOF.gsub(/^ {10}/, '')
          Getting all the characters.

          For when you need everything!
        EOF
        precedence 1

        field :id, 'The id of a character', scope: [:data, nil], type: 'integer'
        field :name, "The character's name", scope: [:data, nil], type: 'string'
      end

      get '/characters', {}, {'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64('finn:hunter2')}"}
    end

    it 'returns a character' do
      doc do
        name 'Fetching a Character'
        description 'For getting information about a Character.'
        path '/characters/:id'

        note 'You need to supply an id!'
        note :warning, "An error will be thrown if you don't supply an id!"

        param :id, 'The id of a character', type: 'integer', required: true

        field :id, 'The id of a character', scope: :character, type: 'integer', example: 42
        field :name, "The character's name", scope: :character, type: 'string'
      end

      get '/characters/1'
    end

    it 'returns 404' do
      doc do
        name 'When a Character cannot be found'
        description 'Returns an error'
        path '/characters/:id'

        note :danger, 'This is an error case'

        field :message, 'Error message', scope: :errors, type: 'string'
      end

      get '/characters/404'
    end

    it 'Deleting a Character' do
      doc do
        # NOTE: name defaults to the description of the RSpec example
        description 'For getting information about a Character.'
        path '/characters/:id'

        param :id, 'The id of a character', type: 'integer', required: true

        field :message, 'Success message', type: 'string'
      end

      delete '/characters/1'
    end

    it 'is unrelated' do
      doc false
    end
  end

  describe 'Places' do
    before do
      doc do
        resource_name 'Places'
        resource_description <<-EOF.gsub(/^ {10}/, '')
          This category consists of locations in the Land of Ooo.

          These are all great places!

          The Characters that live here are great too.
        EOF
      end
    end

    describe 'GET /places' do
      before do
        doc do
          field :id, 'The id of the place', scope: [:data, nil], type: 'integer'
          field :name, "The place's name", scope: [:data, nil], type: 'string'
        end
      end

      it 'returns all places' do
        doc do
          name 'Listing all places'
        end

        get '/places'
      end

      context 'when only a part of the response is relevant' do
        it 'returns all places but only shows one' do
          doc do
            name 'Listing all places with a modified response bod,'
            response_body_after_hook -> (parsed_response_body) {
              parsed_response_body[:data].delete_if { |i| i[:id] == 1 }
              parsed_response_body
            }
          end

          get '/places'
        end
      end

      it 'can store two requests' do
        doc do
          name 'Fetching all places and page 2'

          note :success, 'You can store multiple requests in a single example.'

          param :page, 'The page', type: 'integer'
        end

        get '/places'
        doc << [last_response, last_request] # NOTE: Wrong order

        get '/places?page=2'
      end
    end

    it 'is part of another resource' do
      doc do
        resource_name 'Characters'
        name 'Characters head'

        note 'This example has overridden the resource name set in the `before` block.'
      end

      head '/characters'
    end
  end
end
