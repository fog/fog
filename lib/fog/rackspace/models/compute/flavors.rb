require 'fog/collection'
require 'fog/rackspace/models/servers/flavor'

module Fog
  module Rackspace
    class Compute

      class Flavors < Fog::Collection

        model Fog::Rackspace::Compute::Flavor

        def all
          data = connection.list_flavors_detail.body['flavors']
          load(data)
        end

        def get(flavor_id)
          data = connection.get_flavor_details(flavor_id).body['flavor']
          new(data)
        rescue Fog::Rackspace::Compute::NotFound
          nil
        end

      end

    end
  end
end
