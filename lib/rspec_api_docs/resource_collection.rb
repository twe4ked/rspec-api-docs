module RspecApiDocs
  class ResourceCollection
    def initialize(resources = {})
      @resources = resources
    end

    def all
      @resources.values.sort_by { |resource| [resource.precedence, resource.name] }
    end

    def []=(name, resource)
      @resources[name] = resource
    end

    def [](value)
      @resources[value]
    end
  end
end
