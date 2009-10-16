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
        def list_servers
          request(
            :expects  => 200,
            :method   => 'GET',
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

        def list_servers
        end

      end
    end
  end

end
