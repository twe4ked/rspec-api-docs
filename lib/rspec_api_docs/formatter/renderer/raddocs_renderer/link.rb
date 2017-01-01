module RspecApiDocs
  module Renderer
    class RaddocsRenderer
      class Link
        def self.call(resource_name, example_name)
          "#{resource_name.downcase.gsub(/[^a-z]/, '_')}/#{example_name.downcase.gsub(/[^a-z]/, '_')}.json"
        end
      end
    end
  end
end
