module Fog
  module Compute
    class Clodo
      class Real

        # List all servers (IDs and names only)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'servers'<~Array>:
        #     * 'id'<~String> - Id of server
        #     * 'name'<~String> - Name of server
        #     * 'addresses'<~Hash>:
        #       * 'public'<~Array>:
        #         * 'dosprotect'<~Bool> - DDoS protection enabled
        #         * 'primary_ip'<~Bool> - Is a primary IP-address
        #         * 'isp'<~Bool> - ISPManager license enabled
        #         * 'ip'<~String> - IP-address
        #     * 'imageId'<~String> - ID of OS image installed
        #     * 'type'<~String> - Type (ScaleServer or Virtual Server)
        #     * 'status'<~String> - Server's status
        def list_servers
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'servers'
          )
        end

      end

      class Mock

        def list_servers
          response = Excon::Response.new
          data = list_servers_detail.body['servers']
          servers = []
          for server in data
            servers << server.reject { |key, value| !['id', 'name', 'addresses', 'imageId', 'type', 'status', 'state'].include?(key) }
          end
          response.status = [200, 203][rand(1)]
          response.body = { 'servers' => servers }
          response
        end

      end
    end
  end
end
