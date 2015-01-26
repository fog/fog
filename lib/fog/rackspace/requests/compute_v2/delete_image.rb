module Fog
  module Compute
    class RackspaceV2
      class Real
        # Delete an image
        # @param [String] image_id Id of image to delete
        # @return [Excon::Response] response
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Delete_Image-d1e4957.html
        def delete_image(image_id)
          request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "images/#{image_id}"
          )
        end
      end

      class Mock
        def delete_image(image_id)
          raise Fog::Compute::RackspaceV2::NotFound.new if image_id == Fog::Rackspace::MockData::NOT_FOUND_ID
          response = Excon::Response.new
          response.status = 202
          response.body = ""
        end
      end
    end
  end
end
