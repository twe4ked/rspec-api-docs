require 'active_support/core_ext/string/strip'
require 'rack/test'
require 'sinatra'
require 'rspec_api_docs/dsl'

RSpec.describe RspecApiDocs do
  include Rack::Test::Methods
  include RspecApiDocs::Dsl

  class TestApp < Sinatra::Base
    get '/orders/:id' do
      JSON.dump(
        email: 'email@example.com',
        name: "Order #{params[:id]}",
        paid: true,
      )
    end

    post '/orders' do
      status 201
    end

    get '/characters/:id' do
      JSON.dump(
        id: params[:id],
        name: "Character #{params[:id]}",
      )
    end
  end

  def app
    TestApp
  end

  describe 'Orders' do
    before do
      doc do
        resource_name 'Orders'
        resource_description 'Orders can be created, viewed, and deleted'
      end
    end

    it 'unrelated description' do
      doc do
        name 'Creating an order'
        description 'First, create an order, then make a later request to get it back'

        param :name, 'Name of order', scope: ['order'], type: 'string', required: true
        param :paid, 'If the order has been paid for', scope: ['order'], type: 'integer', required: true
        param :email, 'Email of the user that placed the order', scope: ['order'], type: 'string'

        field :name, 'Name of order', scope: ['order'], type: 'string'
        field :paid, 'If the order has been paid for', scope: ['order'], type: 'integer'
        field :email, 'Email of the user that placed the order', scope: ['order'], type: 'string'
      end

      post '/orders'
      doc << [last_response, last_request] # NOTE: Wrong order

      get '/orders/1'
    end

    it 'Viewing an order' do
      doc do
        description 'Make a request to get an order'
        path '/orders/:id'

        field :name, 'Name of order', scope: ['order'], type: 'string'
        field :paid, 'If the order has been paid for', scope: ['order'], type: 'integer'
        field :email, 'Email of the user that placed the order', scope: ['order'], type: 'string'
      end

      get '/orders/1'
    end

    it 'Deleting an order' do
      doc do
        path '/orders/:id'
        description <<-EOF.strip_heredoc
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Qui est in parvis malis.

          Duo Reges: constructio interrete. Luxuriam non reprehendit, modo sit vacua infinita cupiditate et timore. Non enim iam stirpis bonum quaeret, sed animalis.

          Haec quo modo conveniant, non sane intellego. Verum hoc idem saepe faciamus. Nihilo beatiorem esse Metellum quam Regulum.
        EOF
      end

      get '/orders/1'
    end

    it 'not included' do
      no_doc

      get '/orders/1'
    end
  end

  describe 'Characters' do
    before do
      doc do
        resource_name 'Characters'
        resource_description <<-EOF.strip_heredoc
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Qui est in parvis malis.

          Duo Reges: constructio interrete. Luxuriam non reprehendit, modo sit vacua infinita cupiditate et timore. Non enim iam stirpis bonum quaeret, sed animalis.

          Haec quo modo conveniant, non sane intellego. Verum hoc idem saepe faciamus. Nihilo beatiorem esse Metellum quam Regulum.
        EOF
      end
    end

    it 'Returns a Character' do
      doc do
        description 'For getting information about a Character.'
        path '/characters/:id'

        field :id, 'The id of a character', scope: :character, type: 'integer'
        field :name, "The character's name", scope: :character, type: 'string'
      end

      get '/characters/1'
    end
  end
end
