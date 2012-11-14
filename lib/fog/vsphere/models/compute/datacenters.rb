require 'fog/core/collection'
require 'fog/vsphere/models/compute/datacenter'

module Fog
  module Compute
    class Vsphere

      class Datacenters < Fog::Collection

        model Fog::Compute::Vsphere::Datacenter

        def all(filters = {})
          load connection.list_datacenters(filters)
        end

        def get(name)
          new connection.get_datacenter(name)
        end

      end
    end
  end
end