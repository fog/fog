require 'fog/core/collection'
require 'fog/fogdocker/models/compute/server'

module Fog
  module Compute
    class Fogdocker
      class Servers < Fog::Collection
        model Fog::Compute::Fogdocker::Server

        def all(filters = {})
          load service.container_all(filters)
        end

        def get(id)
          new service.container_get(id)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server
        end
      end
    end
  end
end
