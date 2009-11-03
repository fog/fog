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
        # ==== Returns
        # * response<~Excon::Response>:
        #   * 'image'<~Hash>:
        #     * 'created'<~Time> - Creation time
        #     * 'id'<~Integer> - Id of image
        #     * 'name'<~String> - Name of image
        #     * 'progress'<~String> - Percentage of completion
        #     * 'serverId'<~Integer> - Id of server
        #     * 'status'<~String> - Current status
        def create_image(server_id, options = {})
          data = {
            'image' => {
              'serverId' => server_id
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
