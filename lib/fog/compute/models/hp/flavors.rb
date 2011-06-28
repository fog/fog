require 'fog/core/collection'
require 'fog/compute/models/hp/flavor'

module Fog
  module HP
    class Compute

      class Flavors < Fog::Collection

        model Fog::HP::Compute::Flavor

        def all
          data = connection.list_flavors_detail.body['flavors']
          load(data)
        end

        def get(flavor_id)
          data = connection.get_flavor_details(flavor_id).body['flavor']
          new(data)
        rescue Fog::HP::Compute::NotFound
          nil
        end

      end

    end
  end
end
