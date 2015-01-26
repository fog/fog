module Fog
  module Compute
    class Vsphere
      class Real
        def list_datastores(filters = { })
          datacenter_name = filters[:datacenter]
          # default to show all datastores
          only_active = filters[:accessible] || false
          raw_datastores(datacenter_name).map do |datastore|
            next if only_active and !datastore.summary.accessible
            datastore_attributes(datastore, datacenter_name)
          end.compact
        end

        def raw_datastores(datacenter_name)
          find_raw_datacenter(datacenter_name).datastore
        end
        protected

        def datastore_attributes datastore, datacenter
          {
            :id          => managed_obj_id(datastore),
            :name        => datastore.name,
            :accessible  => datastore.summary.accessible,
            :type        => datastore.summary.type,
            :freespace   => datastore.summary.freeSpace,
            :capacity    => datastore.summary.capacity,
            :uncommitted => datastore.summary.uncommitted,
            :datacenter  => datacenter,
          }
        end
      end
      class Mock
        def list_datastores(datacenter_name)
          []
        end
      end
    end
  end
end
