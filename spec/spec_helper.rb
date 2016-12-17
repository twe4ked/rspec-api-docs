$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rspec_api_docs'
require 'rspec_api_docs/after'
require 'pry'

RSpec.configure do |config|
  config.after &RspecApiDocs::After
end

RspecApiDocs.configure do |config|
  config.output_dir = File.expand_path('../../spec/integration/output', __FILE__)
end
