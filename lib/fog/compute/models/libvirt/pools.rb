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
          load(data)
        end

        # Retrieve the pool by uuid
        def get(uuid)
          pool=connection.lookup_storage_pool_by_uuid(uuid)
          new(:raw => pool)
        end

      end #class

    end #Class
  end #module
end #module
