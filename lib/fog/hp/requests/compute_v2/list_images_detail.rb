module Fog
  module Compute
    class HPV2
      class Real
        # List all images
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
        def list_images_detail(options = {})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'images/detail',
            :query    => options
          )
        end
      end

      class Mock
        def list_images_detail(options = {})
          response = Excon::Response.new

          images = self.data[:images].values
          for image in images
            case image['status']
            when 'SAVING'
              image['status'] = 'ACTIVE'
            end
          end

          response.status = [200, 203][rand(1)]
          response.body = { 'images' => images }
          response
        end
      end
    end
  end
end
