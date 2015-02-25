module Fog
  module Compute
    class Fogdocker
      class Real
        def container_delete(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.key? :id
          container = Docker::Container.get(options[:id], {}, @connection)
          container.delete()
          true
        end
      end

      class Mock
        def container_delete(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.key? :id
          true
        end
      end
    end
  end
end
