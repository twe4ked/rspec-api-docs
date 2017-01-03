module RspecApiDocs
  class Resource
    class Example
      class RequestHeaders
        attr_reader :env

        def self.call(*args)
          new(*args).call
        end

        def initialize(env)
          @env = env
        end

        def call
          headers.reject do |k, v|
            excluded_headers.include?(k)
          end
        end

        private

        # http://stackoverflow.com/a/33235714/826820
        def headers
          Hash[
            *env.select { |k, v| k.start_with? 'HTTP_' }
            .collect { |k, v| [k.sub(/^HTTP_/, ''), v] }
            .collect { |k, v| [k.split('_').collect(&:capitalize).join('-'), v] }
            .sort.flatten
          ]
        end

        def excluded_headers
          RspecApiDocs.configuration.exclude_request_headers
        end
      end
    end
  end
end
