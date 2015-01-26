module Fog
  module Compute
    class Vsphere
      class Real
        def list_interface_types(filters={})
          datacenter_name = filters[:datacenter]
          servertype_name = filters[:servertype]
          get_raw_server_type(servertype_name, datacenter_name)[:supportedEthernetCard].map do | nictype |
            next if filters.key?(:id) and filters[:id] != nictype
            interface_type_attributes(nictype, servertype_name, datacenter_name)
          end.compact
        end

        def interface_type_attributes(nic, servertype, datacenter)
          {
            :id => nic,
            :name => nic,
            :datacenter => datacenter,
            :servertype => servertype
          }
        end
      end
    end
  end
end
