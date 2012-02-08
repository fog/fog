require 'fog/core/collection'
require 'fog/ovirt/models/compute/server'

module Fog
  module Compute
    class Ovirt

      class Servers < Fog::Collection

        model Fog::Compute::Ovirt::Server

        def all(filters = {})
          load connection.list_virtual_machines(filters)
        end

        def get(id)
          new connection.get_virtual_machine(id)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { stopped? }
          server.start
          server
        end

      end
    end
  end
end
