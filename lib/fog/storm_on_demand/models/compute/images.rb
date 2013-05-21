require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/image'

module Fog
  module Compute
    class StormOnDemand

      class Images < Fog::Collection

        model Fog::Compute::StormOnDemand::Image

        def create(options={})
          service.create_image(options)
          true
        end

        def get
          requires :identity
          img = service.get_image_details(:id => identity).body
          new(img)
        end

        def all(options={})
          data = service.list_images(options).body['items']
          load(data)
        end

      end

    end
  end
end
