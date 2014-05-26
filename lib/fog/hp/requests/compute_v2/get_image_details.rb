module Fog
  module Compute
    class HPV2
      class Real
        # Get details for image by id
        #
        # ==== Parameters
        # * 'image_id'<~String> - UUId of image to get details for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'image'<~Hash>:
        #     * 'id'<~String> - UUId of the image
        #     * 'name'<~String> - Name of the image
        #     * 'links'<~Array> - array of image links
        #     * 'server'<~Hash>
        #       * 'id'<~String> - UUId of server from which this snapshot image was created
        #       * 'links'<~Array> - array of server links
        #     * 'updated'<~String> - Last update timestamp for image
        #     * 'created'<~String> - Creation timestamp for image
        #     * 'minDisk'<~String> - Min. amount of diskspace for the image
        #     * 'minRam'<~String> - Min. amount of ram for the image
        #     * 'progress'<~Integer> - Progress through current status
        #     * 'metadata'<~Hash> - metadata for the image
        #     * 'status'<~String> - Status of image
        def get_image_details(image_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "images/#{image_id}"
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
            raise Fog::Compute::HPV2::NotFound
          end
        end
      end
    end
  end
end
