module Fog
  module Compute
    class Ovirt
      class Real
        def destroy_affinity_group(id)
          raise ArgumentError, "instance id is a required parameter" unless id
          client.destroy_affinity_group(id)
        end
      end

      class Mock
        def destroy_affinity_group(id)
          raise ArgumentError, "instance id is a required parameter" unless id
          true
        end
      end
    end
  end
end
