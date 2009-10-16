unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # List all images (IDs and names only)
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'id'<~Integer> - Id of the image
        #     * 'name'<~String> - Name of the image
        #     * 'updated'<~String> - Last update timestamp for image
        #     * 'created'<~String> - Creation timestamp for image
        #     * 'status'<~String> - Status of image
        def list_images
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'images.json'
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def list_images
        end

      end
    end
  end

end
