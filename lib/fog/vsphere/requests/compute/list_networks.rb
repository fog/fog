module Fog
  module Compute
    class Vsphere
      class Real
        def list_networks(filters = { })
          datacenter_name = filters[:datacenter]
          # default to show all networks
          only_active = filters[:accessible] || false
          raw_networks(datacenter_name).map do |network|
            next if only_active and !network.summary.accessible
            network_attributes(network, datacenter_name)
          end.compact
        end

        def raw_networks(datacenter_name)
          find_raw_datacenter(datacenter_name).network
        end

        protected

        def network_attributes network, datacenter
          {
            :id         => managed_obj_id(network),
            :name       => network.name,
            :accessible => network.summary.accessible,
            :datacenter => datacenter,
          }
        end
      end
      class Mock
        def list_networks(datacenter_name)
          []
        end
      end
    end
  end
end
