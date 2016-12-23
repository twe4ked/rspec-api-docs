require 'rack/test'
require 'sinatra'
require 'rspec_api_docs/dsl'

RSpec.describe RspecApiDocs do
  include Rack::Test::Methods
  include RspecApiDocs::Dsl

  class TestApp < Sinatra::Base
    get '/orders/9' do
      JSON.dump(
        email: 'email@example.com',
        name: 'Order 1',
        paid: true,
      )
    end

    post '/orders' do
      status 201
    end
  end

  def app
    TestApp
  end

  before do
    doc do
      resource_name 'Orders'
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

    get '/orders/9'
  end

  it 'Viewing an order' do
    doc do
      description 'Make a request to get an order'

      field :name, 'Name of order', scope: ['order'], type: 'string'
      field :paid, 'If the order has been paid for', scope: ['order'], type: 'integer'
      field :email, 'Email of the user that placed the order', scope: ['order'], type: 'string'
    end

    get '/orders/9'
  end

  it 'Deleting an order' do
    doc

    get '/orders/9'
  end

  it 'not included' do
    no_doc

    get '/orders/9'
  end
end
