require 'fog/core/collection'
require 'fog/libvirt/models/compute/pool'

module Fog
  module Compute
    class Libvirt
      class Pools < Fog::Collection
        model Fog::Compute::Libvirt::Pool

        def all(filter = {})
          load(service.list_pools(filter))
        end

        def get(uuid)
          self.all(:uuid => uuid).first
        end
      end
    end
  end
end
