require 'fog/core/collection'
require 'fog/ovirt/models/compute/host'

module Fog
  module Compute
    class Ovirt

      class Hosts < Fog::Collection

        model Fog::Compute::Ovirt::Host

        def all(filters = {})
          load connection.list_hosts(filters)
        end

        def get(id)
          new connection.get_host(id)
        end

      end
    end
  end
end
