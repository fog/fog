require 'fog/core/collection'
require 'fog/compute/models/libvirt/volume'

module Fog
  module Compute
    class Libvirt

      class Volumes < Fog::Collection

        model Fog::Compute::Libvirt::Volume

        def all 
          data=[]          
          connection.list_storage_pools.each do |poolname|
            pool=connection.lookup_storage_pool_by_name(poolname)
            pool.list_volumes.each do |volumename|
              data << { :raw => pool.lookup_volume_by_name(volumename) }
            end
          end          
          load(data)
        end

        # Retrieve the volume by uuid
        def get(key)
          connection.list_storage_pools.each do |poolname|
            pool=connection.lookup_storage_pool_by_name(poolname)
              volume=pool.lookup_volume_by_name(key)
              unless volume.nil? 
                return new(:raw => volume)
            end
          end          
          
          return nil
        end

      end

    end
  end
end
