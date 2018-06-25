module RspecApiDocs
  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Config.new
    end
  end

  def self.configure
    self.configuration ||= Config.new
    yield configuration
  end

  # Used to control the behaviour of the gem.
  class Config
    attr_accessor \
      :output_dir,
      :renderer,
      :validate_params,
      :exclude_request_headers,
      :exclude_response_headers

    def initialize
      @output_dir = 'docs'
      @renderer = :json
      @validate_params = true
      @exclude_request_headers = []
      @exclude_response_headers = []
    end
  end
end
