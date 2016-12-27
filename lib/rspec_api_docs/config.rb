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

  class Config
    attr_accessor \
      :output_dir,
      :renderer

    def initialize
      @output_dir = 'docs'
      @renderer = :json
    end
  end
end
