require 'fog/core/collection'
require 'fog/gce/models/compute/flavor'

module Fog
  module Compute
    class GCE

      class Flavors < Fog::Collection

        model Fog::Compute::GCE::Flavor

        def all
          data = connection.list_machine_types.body["items"]
          load(data)
        end

        def get(identity)
          data = connection.get_machine_type(identity).body
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
