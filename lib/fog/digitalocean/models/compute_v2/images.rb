require 'fog/digitalocean/models/paging_collection'

module Fog
  module Compute
    class DigitalOceanV2
      class Images < Fog::Compute::DigitalOceanV2::PagingCollection
        model Fog::Compute::DigitalOceanV2::Image

        # Retrieves images
        # @return [Fog::Compute::DigitalOceanV2:Image]
        # @raise [Fog::Compute::DigitalOceanV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::DigitalOceanV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::DigitalOceanV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::DigitalOceanV2::ServiceError]
        # @see https://developers.digitalocean.com/documentation/v2/#list-all-images
        def all(filters = {})
          data = service.list_images(filters)
          links = data.body["links"]
          get_paged_links(links) 
          images = data.body["images"]
          load(images)
        end

        # Retrieves image
        # @param [String] id for image to be returned
        # @return [Fog::Compute::DigitalOceanV2:Image]
        # @raise [Fog::Compute::DigitalOceanV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::DigitalOceanV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::DigitalOceanV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::DigitalOceanV2::ServiceError]
        # @see https://developers.digitalocean.com/documentation/v2/#retrieve-an-existing-image-by-id
        def get(id)
          image = service.get_image_details(id).body['image']
          new(image) if image
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
