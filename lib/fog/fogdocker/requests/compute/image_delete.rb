module Fog
  module Compute
    class Fogdocker
      class Real

        def image_delete(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.has_key? :id
          image = Docker::Image.get(options[:id])
          image.remove()
        end

      end

      class Mock
        def image_delete(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.has_key? :id
          true
        end

      end
    end
  end
end
