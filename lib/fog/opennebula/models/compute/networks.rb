require 'fog/core/collection'
require 'fog/opennebula/models/compute/network'

module Fog
  module Compute
    class OpenNebula
      class Networks < Fog::Collection
        model Fog::Compute::OpenNebula::Network

        def all(filter={})
          load(service.list_networks(filter))
        end

        def get(id)
          self.all({:id => id}).first
        end

      end
    end
  end
end
