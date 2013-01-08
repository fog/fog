module Fog
  module Compute
    class Vsphere
      class Real
        def get_network(name, datacenter_name)
          network = get_raw_network(name, datacenter_name)
          raise(Fog::Compute::Vsphere::NotFound) unless network
          network_attributes(network, datacenter_name)
        end

        protected

        def get_raw_network(name, datacenter_name)
          dc = find_raw_datacenter(datacenter_name)
          dc.networkFolder.find(name)
        end
      end

      class Mock
        def get_network(id)
        end
      end
    end
  end
end
