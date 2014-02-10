module Fog
  module Compute
    class Rackspace
      class Real

        # Get details for image by id
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~Integer> - Id of the image
        #     * 'name'<~String> - Name of the image
        #     * 'serverId'<~Integer> - Id of server image was created from
        #     * 'status'<~Integer> - Status of image
        #     * 'updated'<~String> - Timestamp of last update
        def get_image_details(image_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "images/#{image_id}.json"
          )
        end

      end
    end
  end
end
