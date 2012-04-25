module Fog
  module Compute
    class Libvirt
      class Real
        def pool_action(uuid, action)
          pool = client.lookup_storage_pool_by_uuid uuid
          pool.send(action)
          true
        end
      end

      class Mock
        def pool_action(uuid, action)
          true
        end
      end
    end
  end
end
