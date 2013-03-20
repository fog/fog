require 'fog/core/collection'
require 'fog/vsphere/models/compute/server'

module Fog
  module Compute
    class Vsphere

      class Servers < Fog::Collection

        model Fog::Compute::Vsphere::Server
        attr_accessor :datacenter
        attr_accessor :network
        attr_accessor :cluster
        attr_accessor :resource_pool
        attr_accessor :folder

        # 'folder' => '/Datacenters/vm/Jeff/Templates' will be MUCH faster.
        # than simply listing everything.
        def all(filters = { })
          f = {
            :datacenter    => datacenter,
            :cluster       => cluster,
            :network       => network,
            :resource_pool => resource_pool,
            :folder        => folder
          }.merge(filters)

          load service.list_virtual_machines(f)
        end

        def get(id, datacenter = nil)
          new service.get_virtual_machine id, datacenter
        rescue Fog::Compute::Vsphere::NotFound
          nil
        end
      end
    end
  end
end
