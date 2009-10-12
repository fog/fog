unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # List all servers (IDs and names only)
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
        def get_servers
          request(
            :method => 'GET',
            :path   => 'servers'
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def get_servers
        end

      end
    end
  end

end
