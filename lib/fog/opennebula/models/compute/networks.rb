require 'fog/core/collection'
require 'fog/opennebula/models/compute/network'

module Fog
  module Compute
    class OpenNebula
      class Networks < Fog::Collection
        model Fog::Compute::OpenNebula::Network

        def all(filter={})
          self.get_by_filter(filter)
        end

        def get(id)
          data = service.list_networks({:id => id})
          load(data).first
        rescue Fog::Compute::OpenNebula::NotFound
          nil
        end

        def get_by_name(network)
          data = service.list_networks({:network => network})
          load(data).first
        rescue Fog::Compute::OpenNebula::NotFound
          nil
        end

        def get_by_filter(filter)
          load(service.list_networks(filter))
        end

      end
    end
  end
end
