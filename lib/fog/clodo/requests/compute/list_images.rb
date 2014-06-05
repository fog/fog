module Fog
  module Compute
    class Clodo
      class Real
        # List all images (IDs and names only)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~Integer> - Id of the image
        #     * 'name'<~String> - Name of the image
        #     * 'status'<~String> - Status of the image
        #     * 'vps_type'<~String> - VirtualServer or ScaleServer
        def list_images
          request(
                  :expects  => [200, 203],
                  :method   => 'GET',
                  :path     => 'images'
                  )
        end
      end

      class Mock
        def list_images
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'images' => [
                         { 'name' => 'Debian 6 64 bits',
                           'id' => "541",
                           'vps_type' => 'ScaleServer',
                           'status' => 'ACTIVE' },
                         { 'name' => 'CentOS 5.5 32 bits',
                           'id' => "31",
                           'vps_type' => 'VirtualServer',
                           'status' => 'ACTIVE' }
                        ]
          }
          response
        end
      end
    end
  end
end
