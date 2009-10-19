unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # Get details about a server
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #   * 'server'<~Hash>:
        #     * 'addresses'<~Hash>:
        #       * 'public'<~Array> - public address strings
        #       * 'private'<~Array> - private address strings
        #     * 'flavorId'<~Integer> - Id of servers current flavor
        #     * 'hostId'<~String>
        #     * 'id'<~Integer> - Id of server
        #     * 'imageId'<~Integer> - Id of image used to boot server
        #     * 'metadata'<~Hash> - metadata
        #     * 'name<~String> - Name of server
        #     * 'progress'<~Integer> - Progress through current status
        #     * 'status'<~String> - Current server status
        def get_server_details(id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "servers/#{id}.json"
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def get_server_details
        end

      end
    end
  end

end
