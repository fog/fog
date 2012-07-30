require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/flavor'

module Fog
  module Compute
    class RackspaceV2
      class Flavors < Fog::Collection

        model Fog::Compute::RackspaceV2::Flavor

        def all
          data = connection.list_flavors.body['flavors']
          load(data)
        end

        def get(flavor_id)
          data = connection.get_flavor(flavor_id).body['flavor']
          new(data)
        rescue Fog::Compute::RackspaceV2::NotFound
          nil
        end
      end
    end
  end
end
