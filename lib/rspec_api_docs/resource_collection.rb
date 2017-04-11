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
      @resources[resource.name] ||= resource
    end
  end
end
