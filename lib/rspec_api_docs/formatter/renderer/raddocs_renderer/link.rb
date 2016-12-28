module RspecApiDocs
  module Renderer
    class RaddocsRenderer
      class Link
        def self.call(resource_name, example)
          "#{resource_name.downcase}/#{example.name.parameterize.underscore}.json"
        end
      end
    end
  end
end
