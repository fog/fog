unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # List server details for id
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #   * 'servers'<~Array>:
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
