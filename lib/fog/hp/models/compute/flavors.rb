require 'fog/core/collection'
require 'fog/hp/models/compute/flavor'

module Fog
  module Compute
    class HP
      class Flavors < Fog::Collection
        model Fog::Compute::HP::Flavor

        def all
          data = service.list_flavors_detail.body['flavors']
          load(data)
        end

        def get(flavor_id)
          data = service.get_flavor_details(flavor_id).body['flavor']
          new(data)
        rescue Fog::Compute::HP::NotFound
          nil
        end
      end
    end
  end
end
