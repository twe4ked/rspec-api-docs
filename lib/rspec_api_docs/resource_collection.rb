module RspecApiDocs
  class ResourceCollection
    def initialize(resources = {})
      @resources = resources
    end

    def all
      @resources.values.sort_by { |resource| [resource.precedence, resource.name] }
    end

    def add_example(rspec_example)
      resource = Resource.new(rspec_example)

      existing_resource = @resources[resource.name]
      if existing_resource
        existing_resource.precedence = [existing_resource.precedence, resource.precedence].min
        resource = existing_resource
      else
        @resources[resource.name] = resource
      end

      resource.add_example Resource::Example.new(rspec_example)
    end
  end
end
