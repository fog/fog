require 'fog/core/collection'
require 'fog/vsphere/models/compute/network'

module Fog
  module Compute
    class Vsphere

      class Networks < Fog::Collection

        model Fog::Compute::Vsphere::Network
        attr_accessor :datacenter

        def all(filters = {})
          f = { :datacenter => datacenter }.merge(filters)
          load service.list_networks(f)
        end

        def get(id)
          requires :datacenter
          new service.get_network(id, datacenter)
        end
      end
    end
  end
end
