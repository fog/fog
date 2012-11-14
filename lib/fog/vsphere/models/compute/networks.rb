require 'fog/core/collection'
require 'fog/vsphere/models/compute/network'

module Fog
  module Compute
    class Vsphere

      class Networks < Fog::Collection

        model Fog::Compute::Vsphere::Network
        attr_accessor :datacenter

        def all(filters = {})
          load connection.list_networks(filters.merge(:datacenter => datacenter))
        end

        def get(id)
          requires :datacenter
          new connection.get_network(id, datacenter)
        end

      end
    end
  end
end
