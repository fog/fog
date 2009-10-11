unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # List all servers (IDs and names only)
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'publicIp'<~String> - The acquired address
        #     * 'requestId'<~String> - Id of the request
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
