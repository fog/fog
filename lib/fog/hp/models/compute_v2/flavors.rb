require 'fog/core/collection'
require 'fog/hp/models/compute_v2/flavor'

module Fog
  module Compute
    class HPV2

      class Flavors < Fog::Collection

        model Fog::Compute::HPV2::Flavor

        def all(options = {})
          data = service.list_flavors_detail(options).body['flavors']
          load(data)
        end

        def get(flavor_id)
          data = service.get_flavor_details(flavor_id).body['flavor']
          new(data)
        rescue Fog::Compute::HPV2::NotFound
          nil
        end

      end

    end
  end
end
