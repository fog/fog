require 'fog/core/collection'
require 'fog/libvirt/models/compute/network'

module Fog
  module Compute
    class Libvirt
      class Networks < Fog::Collection
        model Fog::Compute::Libvirt::Network

        def all(filter={})
          load(service.list_networks(filter))
        end

        def get(uuid)
          self.all(:uuid => uuid).first
        end
      end
    end
  end
end
