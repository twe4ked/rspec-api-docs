module RspecApiDocs
  module Renderer
    class RaddocsRenderer
      class Link
        def self.call(resource)
          "#{resource.name.downcase}/#{resource.example_name.parameterize.underscore}.json"
        end
      end
    end
  end
end
