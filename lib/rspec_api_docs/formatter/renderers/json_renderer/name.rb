module RspecApiDocs
  class JSONRenderer
    class Name
      def self.call(name:, scope:)
        scope = Array(scope)
        if scope.empty?
          name
        else
          scope.each_with_index.inject('') do |str, (part, index)|
            str << (index == 0 ? part : "[#{part}]").to_s
          end + "[#{name}]"
        end
      end
    end
  end
end
