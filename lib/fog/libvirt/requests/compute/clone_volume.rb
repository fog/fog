module Fog
  module Compute
    class Libvirt
      class Real
        def clone_volume (pool_name, xml, name)
          vol = client.lookup_storage_pool_by_name(pool_name).lookup_volume_by_name(name)
          client.lookup_storage_pool_by_name(pool_name).create_vol_xml_from(xml, vol)
        end
      end

      class Mock
        def clone_volume(pool_name, xml, name)
          Fog::Compute::Libvirt::Volume.new({:pool_name => pool_name, :xml => xml})
        end
      end
    end
  end
end
