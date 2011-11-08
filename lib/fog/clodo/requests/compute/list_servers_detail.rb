module Fog
  module Compute
    class Clodo
      class Real

        # List all servers details
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'servers'<~Array>:
        #     * 'id'<~Integer> - Id of server
        #     * 'name<~String> - Name of server
        #     * 'imageId'<~Integer> - Id of image used to boot server
        #     * 'status'<~String> - Current server status
        #     * 'addresses'<~Hash>:
        #       * 'public'<~Array> - public address strings
        def list_servers_detail
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'servers/detail'
          )
        end

      end

      class Mock

        def list_servers_detail
          response = Excon::Response.new

          servers = self.data[:servers].values
          for server in servers
            case server['status']
            when 'is_install'
              if Time.now - self.data[:last_modified][:servers][server['id']] > Fog::Mock.delay * 2
                server['status'] = 'is_running'
              end
            end
          end

          response.status = [200, 203][rand(1)]
          response.body = { 'servers' => servers }
          response
        end

      end
    end
  end
end
