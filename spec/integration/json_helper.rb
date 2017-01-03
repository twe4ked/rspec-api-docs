RspecApiDocs.configure do |config|
  config.output_dir = File.expand_path('../output/json', __FILE__)
  config.renderer = :json
end

RspecApiDocs.configure do |config|
  config.exclude_request_headers = %w[Authorization]
end
