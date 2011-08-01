require 'fog/core/collection'
require 'fog/compute/models/libvirt/pool'

module Fog
  module Compute
    class Libvirt

      class Pools < Fog::Collection

        model Fog::Compute::Libvirt::Pool

        def all 
          data=[]          
          connection.list_storage_pools.each do |poolname|
            pool=connection.lookup_storage_pool_by_name(poolname)            
            data << { :raw => pool }
          end          
          connection.list_defined_storage_pools.each do |poolname|
            data << {
              :raw => connection.lookup_storage_pool_by_name(poolname)
            }
          end
          
          
          load(data)
        end

        # Retrieve the pool by type
        def get(param)
          pool=nil
          pool=get_by_uuid(param[:uuid]) if param.has_key?(:uuid)
          pool=get_by_name(param[:name]) if param.has_key?(:name)
          return pool
        end

        # Retrieve the pool by uuid        
        def get_by_uuid(uuid)
          pool=connection.lookup_storage_pool_by_uuid(uuid)
          new(:raw => pool)
        end

        # Retrieve the pool by name
        def get_by_name(name)
          pool=connection.lookup_storage_pool_by_name(name)
          new(:raw => pool)
        end

      end #class

    end #Class
  end #module
end #module
