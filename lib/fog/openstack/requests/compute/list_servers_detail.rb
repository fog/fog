module Fog
  module Compute
    class OpenStack
      class Real

        def list_servers_detail
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'servers/detail.json'
          )
        end

      end

      class Mock

        def list_servers_detail
          response = Excon::Response.new

          servers = self.data[:servers].values
          for server in servers
            case server['status']
            when 'BUILD'
              if Time.now - self.data[:last_modified][:servers][server['id']] > Fog::Mock.delay * 2
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
