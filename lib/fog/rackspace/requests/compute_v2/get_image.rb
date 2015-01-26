module Fog
  module Compute
    class RackspaceV2
      class Real
        # Retrieves image detail
        # @param [String] image_id
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * image [Hash]:
        #       * OS-DCF:diskConfig [String] - The disk configuration value.
        #       * created [String] - created timestamp
        #       * id [String] - id of image
        #       * metadata [Hash] - image metadata
        #       * minDisk [Fixnum]
        #       * minRam [Fixnum]
        #       * name [String] - name of image
        #       * progress [Fixnum] - progress complete. Value is from 0 to 100.
        #       * status [String] - status of current image
        #       * updated [String] - updated timestamp
        #       * links [Array] - links to flavor
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Get_Image_Details-d1e4848.html
        def get_image(image_id)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "images/#{Fog::Rackspace.escape(image_id)}"
          )
        end
      end

      class Mock
        def get_image(image_id)
          image = self.data[:images][image_id]
          if image.nil?
            raise Fog::Compute::RackspaceV2::NotFound
          else
            response(:body => {"image" => image})
          end
        end
      end
    end
  end
end
