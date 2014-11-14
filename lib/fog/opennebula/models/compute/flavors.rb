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
          data = service.template_pool({:id => flavor_id})
          load(data).first
        rescue Fog::Compute::OpenNebula::NotFound
          nil
        end

        def get_by_name(flavor_name)
          data = service.template_pool({:name => flavor_name})
          load(data)
        rescue Fog::Compute::OpenNebula::NotFound
          nil
        end

        def get_by_filter(flavor_filter)
          data = service.template_pool(flavor_filter)
          load(data)
        rescue Fog::Compute::OpenNebula::NotFound
          nil
        end

      end

    end
  end
end
