module Fog
  module Compute
    class Libvirt
      class Real
        def create_volume(pool_name, xml)
          client.lookup_storage_pool_by_name(pool_name).create_vol_xml(xml)
        end
      end

      class Mock
        def create_volume(pool_name, xml)

        end
      end
    end
  end
end
