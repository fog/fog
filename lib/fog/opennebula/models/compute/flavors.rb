require 'fog/core/collection'
require 'fog/opennebula/models/compute/flavor'

module Fog
  module Compute
    class OpenNebula

      class Flavors < Fog::Collection

        model Fog::Compute::OpenNebula::Flavor

        def all
          data = service.template_pool
          load(data)
        end

        def get(flavor_id)
          #data = service.get_flavor_details(flavor_id)
          #new(data)
          data = service.template_pool({:id => flavor_id})
          load(data).first
        rescue Fog::Compute::OpenNebula::NotFound
          nil
        end

      end

    end
  end
end
