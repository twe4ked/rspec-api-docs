module RspecApiDocs
  module Renderer
    class RaddocsRenderer
      class Link
        def self.call(resource_name, example_name)
          "#{resource_name.parameterize.underscore}/#{example_name.parameterize.underscore}.json"
        end
      end
    end
  end
end
