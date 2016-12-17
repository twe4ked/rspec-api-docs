require 'active_support/inflector'

module RspecApiDocs
  class Resource
    attr_reader :example

    def initialize(example)
      @example = example
    end

    def name
      metadata.fetch(:resource_name, example.metadata[:example_group][:description])
    end

    def example_name
      metadata.fetch(:example_name, example.description)
    end

    def description
      metadata[:description]
    end

    def parameters
      metadata.fetch(:parameters, []).map do |name, field|
        result = {}
        result[:required] = true if field[:required]
        result[:scope] = field[:scope].join unless field[:scope].empty?
        result = result.merge(
          name: name,
          description: field[:description],
        )
        result
      end
    end

    def response_fields
      metadata.fetch(:fields, []).map do |name, field|
        {
          scope: field[:scope].join,
          Type: field[:type],
          name: name,
          description: field[:description],
        }
      end
    end

    def requests
      reqs = metadata.fetch(:requests, []).reject { |x| x.any?(&:nil?) }
      reqs.map do |request, response|
        {
          request_method: request.request_method,
          request_path: request_path(request),
          request_body: request_body(request.body),
          request_headers: request_headers(request.env),
          request_query_parameters: request.params,
          request_content_type: request.content_type,
          response_status: response.status,
          response_status_text: response_status_text(response.status),
          response_body: response_body(response.body),
          response_headers: response.headers,
          response_content_type: response.content_type,
          curl: curl,
        }
      end
    end

    # NOTE: returns the first route requested
    def path
      metadata.fetch(:path) do
        reqs = metadata.fetch(:requests, []).reject { |x| x.any?(&:nil?) }
        return if reqs.empty?
        reqs.first.first.path
      end
    end

    # NOTE: returns the first HTTP method used
    def http_method
      reqs = metadata.fetch(:requests, []).reject { |x| x.any?(&:nil?) }
      return if reqs.empty?
      reqs.first.first.request_method
    end

    def link
      "#{name.downcase}/#{example_name.parameterize.underscore}.json"
    end

    def groups
      'all'
    end

    private

    # http://stackoverflow.com/a/33235714/826820
    def request_headers(env)
      Hash[
        *env.select { |k,v| k.start_with? 'HTTP_' }
          .collect { |k,v| [k.sub(/^HTTP_/, ''), v] }
          .collect { |k,v| [k.split('_').collect(&:capitalize).join('-'), v] }
          .sort.flatten
      ]
    end

    def request_path(request)
      URI(request.path).tap do |uri|
        uri.query = request.query_string unless request.query_string.empty?
      end.to_s
    end

    def request_body(body)
      body = body.read
      body.empty? ? nil : body
    end

    def response_body(body)
      body.empty? ? nil : body
    end

    def response_status_text(status)
      Rack::Utils::HTTP_STATUS_CODES[status]
    end

    # TODO
    def curl
    end

    def metadata
      example.metadata[METADATA_NAMESPACE]
    end
  end
end
