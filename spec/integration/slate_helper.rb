RspecApiDocs.configure do |config|
  config.output_dir = File.expand_path('../output/slate', __FILE__)
  config.renderer = :slate
end

RspecApiDocs.configure do |config|
  config.exclude_request_headers = %w[Authorization]
end
