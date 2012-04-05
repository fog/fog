module Fog
  module Compute
    class Libvirt
      class Real
        def list_pool_volumes(uuid)
          pool = client.lookup_storage_pool_by_uuid uuid
          pool.list_volumes.map do |volume_name|
            volume_to_attributes(pool.lookup_volume_by_name(volume_name))
          end
        end

      end

      class Mock
        def list_pool_volumes(uuid)

        end
      end
    end
  end
end
