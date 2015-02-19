module Fog
  module Compute
    class Fogdocker
      class Real
        def image_delete(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.key? :id
          image = Docker::Image.get(options[:id], {}, @connection)
          image.remove()
        end
      end

      class Mock
        def image_delete(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.key? :id
          "[{'Deleted':'b15c1423ba157d0f7ac83cba178390c421bb8d536e7e7857580fc10f2d53e1b9'}]"
        end
      end
    end
  end
end
