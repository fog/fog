module Fog
  module Compute
    class RackspaceV2
      class Real

        # Create an image from a running server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to create image from
        # * name - Name of image
        # * options<~Hash> - Name

        def create_image(server_id, name, options = {})
          data = {
            'createImage' => {
              'name' => name
            }
          }
          data['createImage'].merge!(options)          
          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 202,
            :method   => 'POST',
            :path     => "servers/#{server_id}/action"
          )
        end
      end

      class Mock

        def create_image(server_id, name, options = {})
          response = Excon::Response.new
          response.status = 202
          response.body = ""
          response
        end

      end
    end
  end
end
