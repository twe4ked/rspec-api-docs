RspecApiDocs.configure do |config|
  config.output_dir = File.expand_path('../output/raddocs', __FILE__)
  config.renderer = :raddocs
end
