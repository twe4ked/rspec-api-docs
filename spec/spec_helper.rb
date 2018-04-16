$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rspec_api_docs'
require 'rspec_api_docs/after'

RSpec.configure do |config|
  config.after &RspecApiDocs::After::Hook
end
