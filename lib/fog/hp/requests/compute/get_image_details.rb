module Fog
  module Compute
    class HP
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

      class Mock
        def get_image_details(image_id)
          response = Excon::Response.new
          if image = list_images_detail.body['images'].find {|_| _['id'] == image_id}
            response.status = [200, 203][rand(1)]
            response.body = { 'image' => image }
            response
          else
            raise Fog::Compute::HP::NotFound
          end
        end
      end
    end
  end
end
