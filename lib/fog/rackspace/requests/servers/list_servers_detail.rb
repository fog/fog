unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # List all servers details
        #
        # ==== Returns
        # * response<~Excon::Response>:
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
        def list_servers_detail
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'servers/detail.json'
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def list_servers_detail
          response = Excon::Response.new

          servers = Fog::Rackspace::Servers.data[:servers].values
          for server in servers
            case server['status']
            when 'BUILD'
              if Time.now - Fog::Rackspace::Servers.data[:last_modified][server['id']] > 2
                server['status'] = 'ACTIVE'
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
