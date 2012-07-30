require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/image'

module Fog
  module Compute
    class RackspaceV2
      class Images < Fog::Collection

        model Fog::Compute::RackspaceV2::Image

        def all
          data = connection.list_images.body['images']
          load(data)
        end

        def get(image_id)
          data = connection.get_image(image_id).body['image']
          new(data)
        rescue Fog::Compute::RackspaceV2::NotFound
          nil
        end
      end
    end
  end
end
