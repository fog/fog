require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/image'

module Fog
  module Compute
    class RackspaceV2
      class Images < Fog::Collection

        model Fog::Compute::RackspaceV2::Image

        # Returns list of images 
        # @return [Array<Fog::Compute::RackspaceV2::Image>] Retrieves a list images.
        # @note Fog's current implementation only returns 1000 images.
        # @note Fog does not retrieve all image details. Please use get to retrieve all details for a specific image.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Images-d1e4435.html
        def all
          data = service.list_images.body['images']
          load(data)
        end

        # Retrieve image
        # @param [String] image_id id of image
        # @return [Fog::Compute::RackspaceV2:Image] image
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Get_Image_Details-d1e4848.html 
        def get(image_id)
          data = service.get_image(image_id).body['image']
          new(data)
        rescue Fog::Compute::RackspaceV2::NotFound
          nil
        end
      end
    end
  end
end
