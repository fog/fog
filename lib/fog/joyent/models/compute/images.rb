require 'fog/core/collection'
require 'fog/joyent/models/compute/image'

module Fog
  module Compute

    class Joyent
      class Images < Fog::Collection

        model Fog::Compute::Joyent::Image

        def all
          load(service.list_datasets().body)
        end

        def get(id)
          data = service.get_dataset(id).body
          new(data)
        end

      end # Images
    end # Joyent

  end # Compute
end # Fog
