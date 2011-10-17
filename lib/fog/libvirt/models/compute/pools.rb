require 'fog/core/collection'
require 'fog/libvirt/models/compute/pool'

module Fog
  module Compute
    class Libvirt

      class Pools < Fog::Collection

        model Fog::Compute::Libvirt::Pool

        def all(filter=nil)
          data=[]
          if filter.nil?
            connection.raw.list_storage_pools.each do |poolname|
              pool=connection.raw.lookup_storage_pool_by_name(poolname)
              data << { :raw => pool }
            end
            connection.raw.list_defined_storage_pools.each do |poolname|
              data << {
                :raw => connection.raw.lookup_storage_pool_by_name(poolname)
              }
            end
          else
            pool=nil
            begin
              pool=get_by_uuid(filter[:uuid]) if filter.has_key?(:uuid)
              pool=get_by_name(filter[:name]) if filter.has_key?(:name)
            rescue ::Libvirt::RetrieveError
              return nil
            end
            data << { :raw => pool}
          end

          load(data)
        end

        def get(uuid)
          self.all(:uuid => uuid).first
        end

        #private # Making these private, screws up realod
        # Retrieve the pool by uuid
        def get_by_uuid(uuid)
          pool=connection.raw.lookup_storage_pool_by_uuid(uuid)
          return pool
        end

        # Retrieve the pool by name
        def get_by_name(name)
          pool=connection.raw.lookup_storage_pool_by_name(name)
          return pool
          #          new(:raw => pool)
        end

      end #class

    end #Class
  end #module
end #module
