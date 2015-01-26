require 'fog/core/collection'
require 'fog/joyent/models/compute/flavor'

module Fog
  module Compute
    class Joyent
      class Flavors < Fog::Collection
        model Fog::Compute::Joyent::Flavor

        def all
          load(service.list_packages().body)
        end

        def get(id)
          data = service.get_package(id).body
          new(data)
        end
      end
    end # Joyent
  end # Compute
end # Fog
