require 'fog/core/collection'
require 'fog/slicehost/models/compute/flavor'

module Fog
  module Compute
    class Slicehost

      class Flavors < Fog::Collection

        model Fog::Compute::Slicehost::Flavor

        def all
          data = connection.get_flavors.body['flavors']
          load(data)
        end

        def get(flavor_id)
          data = connection.get_flavor(flavor_id).body
          new(data)
        rescue Excon::Errors::Forbidden
          nil
        end

      end

    end
  end
end
