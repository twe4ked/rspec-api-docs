RspecApiDocs.configure do |config|
  config.output_dir = File.expand_path('../output/json', __FILE__)
  config.renderer = :json
end
