unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # Create a new server
        #
        # ==== Parameters
        # * flavor_id<~Integer> - Id of flavor for server
        # * image_id<~Integer> - Id of image for server
        # * name<~String> - Name of server
        # * options<~Hash>:
        #   * 'metadata'<~Hash> - Up to 5 key value pairs containing 255 bytes of info
        #   * 'name'<~String> - Name of server, defaults to "slice#{id}"
        #   * 'personality'<~Array>: Up to 5 files to customize server
        #     * file<~Hash>:
        #       * 'contents'<~String> - Contents of file (10kb total of contents)
        #       * 'path'<~String> - Path to file (255 bytes total of path strings)
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #   * 'servers'<~Hash>:
        #     * 'adminPass'<~String> - Admin password for server
        #     * 'id'<~Integer> - Id of server
        #     * 'name<~String> - Name of server
        #     * 'imageId'<~Integer> - Id of image used to boot server
        #     * 'flavorId'<~Integer> - Id of servers current flavor
        #     * 'hostId'<~String>
        #     * 'status'<~String> - Current server status
        #     * 'progress'<~Integer> - Progress through current status
        #     * 'addresses'<~Hash>:
        #       * 'public'<~Array> - public address strings
        #       * 'private'<~Array> - private address strings
        #     * 'metadata'<~Hash> - metadata
        def create_server(flavor_id, image_id, options = {})
          data = {
            'server' => {
              'flavorId'  => flavor_id,
              'imageId'   => image_id
            }
          }
          if options['metadata']
            data['server']['metadata'] = options['metadata']
          end
          if options['name']
            data['server']['name'] = options['name']
          end
          if options['personality']
            data['server']['personality'] = []
            for file in options['personality']
              data['server']['personality'] << {
                'contents'  => Base64.encode64(file['contents']),
                'path'      => file['path']
              }
            end
          end
          p data
          request(
            :body     => data.to_json,
            :expects  => 202,
            :method   => 'POST',
            :path     => 'servers.json'
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def create_server
        end

      end
    end
  end

end
