unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # Create an image from a running server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to create image from
        # * options<~Hash> - Name
        #
        def create_image(server_id, options = {})
          data = {
            'image' => {
              "serverId" => server_id
            }
          }
          if options['name']
            data['image']['name'] = options['name']
          end
          request(
            :body     => data.to_json,
            :expects  => 202,
            :method   => 'POST',
            :path     => "images"
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def create_image
        end

      end
    end
  end

end
