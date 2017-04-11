module RspecApiDocs
  class ResourceCollection
    def initialize(resources = {})
      @resources = resources
    end

    def all
      @resources.values.sort_by { |resource| [resource.precedence, resource.name] }
    end

    def [](rspec_example)
      resource = Resource.new(rspec_example)

      existing_resource = @resources[resource.name]
      if existing_resource
        existing_resource.precedence = [existing_resource.precedence, resource.precedence].min
        existing_resource
      else
        @resources[resource.name] = resource
      end
    end
  end
end
