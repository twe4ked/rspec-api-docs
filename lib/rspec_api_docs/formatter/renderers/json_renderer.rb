require 'json'

module RspecApiDocs
  class JSONRenderer
    attr_reader :resources_grouped_by_name

    def initialize(resources)
      @resources_grouped_by_name = resources.group_by(&:name)
    end

    def render
      FileUtils.mkdir_p output_file.dirname

      File.open(output_file, 'w') do |f|
        f.write JSON.pretty_generate(output) + "\n"
      end
    end

    private

    def output
      Hash[resources_grouped_by_name.map do |name, resources|
        [
          name,
          resources.map do |resource|
            {
              description: resource.description,
              name: resource.example_name,
              http_method: resource.http_method,
              parameters: parameters(resource.parameters),
              path: resource.path,
              requests: resource.requests,
              response_fields: response_fields(resource.response_fields),
            }
          end
        ]
      end]
    end

    def parameters(parameters)
      parameters.map do |parameter|
        {
          name: parameter.name,
          description: parameter.description,
          scope: parameter.scope,
          required: parameter.required,
        }
      end
    end

    def response_fields(fields)
      fields.map do |field|
        {
          name: field.name,
          description: field.description,
          scope: field.scope,
          type: field.type,
        }
      end
    end

    def output_file
      Pathname.new(RspecApiDocs.configuration.output_dir) + 'index.json'
    end
  end
end
