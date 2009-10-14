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
        def get_images
          request(
            :expects  => 200,
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

        def get_images
        end

      end
    end
  end

end
