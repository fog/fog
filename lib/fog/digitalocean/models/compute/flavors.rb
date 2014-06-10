require 'fog/core/collection'
require 'fog/digitalocean/models/compute/flavor'

module Fog
  module Compute
    class DigitalOcean
      class Flavors < Fog::Collection
        model Fog::Compute::DigitalOcean::Flavor

        def all
          load service.list_flavors.body['sizes']
        end

        def get(id)
          all.find { |f| f.id == id }
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
