require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/flavor'

module Fog
  module Compute
    class RackspaceV2
      class Flavors < Fog::Collection

        model Fog::Compute::RackspaceV2::Flavor

        # Retrieves information for all available flavors
        # @return [Array<Fog::Compute::RackspaceV2::Flavor>] list of flavors
        # @note Fog's currentl implementation only returns 1000 flavors.
        # @note Fog does not retrieve all flavor details. Please use #get to retrieve all details for a specific flavor.
        def all
          data = service.list_flavors.body['flavors']
          load(data)
        end

        # Retrieve image
        # @param [String] flavor_id id of flavor
        # @return [Fog::Compute::RackspaceV2::Flavor] flavor
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Get_Flavor_Details-d1e4317.html
        def get(flavor_id)          
          data = service.get_flavor(flavor_id).body['flavor']
          new(data)
        rescue Fog::Compute::RackspaceV2::NotFound
          nil
        end
      end
    end
  end
end
