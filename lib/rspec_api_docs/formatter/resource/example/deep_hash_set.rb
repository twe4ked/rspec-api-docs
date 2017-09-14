module RspecApiDocs
  class Resource
    class Example
      class DeepHashSet
        attr_reader :hash, :keys, :value, :node

        def self.call(*args)
          new(*args).call
        end

        def initialize(hash, keys, value)
          @hash = hash
          @keys = keys
          @value = value
          @node = []
        end

        def call
          keys.each_with_index do |key, index|
            case
            when key.nil?
              deep_set_value_at_array(index)
              break
            when index == keys.size - 1
              set_value_at(key)
            else
              node << key
            end
          end

          hash
        end

        private

        attr_reader :node

        def deep_set_value_at_array(index)
          array = deep_find(hash, node)
          array && array.each do |inner_hash|
            DeepHashSet.call(inner_hash, keys[index+1..-1], value)
          end
        end

        def set_value_at(key)
          part = deep_find(hash, node)
          if part.is_a?(Hash) && !part[key].nil?
            part[key] = value
          end
        end

        def deep_find(hash, keys)
          keys.inject(hash) { |h, k| h && h[k] }
        end
      end
    end
  end
end
