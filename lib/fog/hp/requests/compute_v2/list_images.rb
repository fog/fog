module Fog
  module Compute
    class HPV2
      class Real
        # List all images (IDs and names only)
        #
        # ==== Parameters
        # * options<~Hash>: filter options
        #   * 'name'<~String> - Filters by the name of the image
        #   * 'status'<~String> - Filters by the status of the image
        #   * 'server'<~String> - Filters by the UUId of the server
        #   * 'marker'<~String> - The ID of the last item in the previous list
        #   * 'limit'<~Integer> - Sets the page size
        #   * 'changes-since'<~DateTime> - Filters by the changes-since time. The list contains servers that have been deleted since the changes-since time.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'images'<~Array>:
        #     * 'id'<~String> - UUId of the image
        #     * 'name'<~String> - Name of the image
        #     * 'links'<~Array> - array of image links
        def list_images(options = {})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'images',
            :query    => options
          )
        end
      end

      class Mock
        def list_images(options = {})
          response = Excon::Response.new
          data = list_images_detail.body['images']
          images = []
          for image in data
            images << image.reject { |key, _| !['id', 'name', 'links'].include?(key) }
          end
          response.status = [200, 203][rand(1)]
          response.body = { 'images' => images }
          response
        end
      end
    end
  end
end
