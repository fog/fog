require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/image'

module Fog
  module Compute
    class RackspaceV2
      class Images < Fog::Collection
        # @!attribute [rw] name
        # @return [String] Given a string value x, filters the list of images by image name.
        attribute :name

        # @!attribute [rw] status
        # @return [String] Given a string value x, filters the list of images by status.
        # @note Possible values are ACTIVE, DELETED, ERROR, SAVING, and UNKNOWN.
        attribute :status

        # @!attribute [rw] marker
        # @return [String] Given a string value x, return object names greater in value than the specified marker.
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/List_Large_Number_of_Objects-d1e1521.html
        attribute :marker

        # @!attribute [rw] limit
        # @return [Integer] For an integer value n, limits the number of results to at most n values.
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/List_Large_Number_of_Objects-d1e1521.html
        attribute :limit

        # @!attribute [rw] type
        # @return [String] Given a string value x, filters the list of images by type.
        # @note Valid values are BASE and SNAPSHOT
        attribute :type

        model Fog::Compute::RackspaceV2::Image

        # Returns list of images
        # @return [Fog::Compute::RackspaceV2::Images] Retrieves a list images.
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @note Fog's current implementation only returns 1000 images.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Images-d1e4435.html
        def all(options = {})
          options = {
            'name'          => name,
            'status'        => status,
            'marker'        => marker,
            'limit'         => limit,
            'type'          => type
          }.merge!(options)
          merge_attributes(options)

          data = service.list_images_detail(options).body['images']
          load(data)
        end

        # Retrieve image
        # @param [String] image_id id of image
        # @return [Fog::Compute::RackspaceV2:Image] image
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
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
