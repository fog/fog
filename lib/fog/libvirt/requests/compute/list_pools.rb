module Fog
  module Compute
    class Libvirt
      class Real
        def list_pools(filter = { })
          data=[]
          if filter.has_key?(:name)
            data << find_pool_by_name(filter[:name])
          elsif filter.has_key?(:uuid)
            data << find_pool_by_uuid(filter[:uuid])
          else
            (client.list_storage_pools + client.list_defined_storage_pools).each do |name|
              data << find_pool_by_name(name)
            end
          end
          data
        end

        private
        def pool_to_attributes(pool)
          states=[:inactive, :building, :running, :degrated, :inaccessible]
          {
            :uuid           => pool.uuid,
            :persistent     => pool.persistent?,
            :autostart      => pool.autostart?,
            :active         => pool.active?,
            :name           => pool.name,
            :allocation     => pool.info.allocation,
            :capacity       => pool.info.capacity,
            :num_of_volumes => pool.num_of_volumes,
            :state          => states[pool.info.state]
          }
        end

        def find_pool_by_name name
          pool_to_attributes(client.lookup_storage_pool_by_name(name))
        rescue ::Libvirt::RetrieveError
          nil
        end

        def find_pool_by_uuid uuid
          pool_to_attributes(client.lookup_storage_pool_by_uuid(uuid))
        rescue ::Libvirt::RetrieveError
          nil
        end

      end

      class Mock
        def list_pools(filter = { })

        end
      end
    end
  end
end
