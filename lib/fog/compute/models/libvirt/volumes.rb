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

        # Retrieve the volume by type
        def get(param)
          volume=nil
          volume=get_by_key(param[:key]) if param.has_key?(:key)
          volume=get_by_path(param[:path]) if param.has_key?(:path)
          volume=get_by_name(param[:name]) if param.has_key?(:name)
          return volume
        end
        
        # Retrieve the volume by name
        def get_by_name(name)
          connection.list_storage_pools.each do |poolname|
            pool=connection.lookup_storage_pool_by_name(poolname)
              volume=pool.lookup_volume_by_name(name)
              unless volume.nil? 
                return new(:raw => volume)
            end
          end          
          
          return nil
        end

        # Retrieve the volume by key
        def get_by_key(key)
          connection.list_storage_pools.each do |poolname|
            pool=connection.lookup_storage_pool_by_name(poolname)
              volume=pool.lookup_volume_by_key(key)
              unless volume.nil? 
                return new(:raw => volume)
            end
          end          
          
          return nil
        end

        # Retrieve the volume by key
        def get_by_path(path)
          connection.list_storage_pools.each do |poolname|
            pool=connection.lookup_storage_pool_by_name(poolname)
              volume=pool.lookup_volume_by_key(path)
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
