unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # List all images (IDs and names only)
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'publicIp'<~String> - The acquired address
        #     * 'requestId'<~String> - Id of the request
        def get_images
          request(
            :method => 'GET',
            :path   => 'images'
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
