module Fog
  module Compute
    class Ovirt
      class Real

        def add_volume(id, options = {})
          raise ArgumentError, "instance id is a required parameter" unless id

          client.add_volume(id, options)
        end

      end

      class Mock
        def add_volume(id, options = {})
          raise ArgumentError, "instance id is a required parameter" unless id
          true
        end

      end
    end
  end
end