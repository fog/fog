module Fog
  module Compute
    class OpenStack
      class Real

        def list_servers
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'servers.json'
          )
        end

      end

      class Mock

        def list_servers
          response = Excon::Response.new
          data = list_servers_detail.body['servers']
          servers = []
          for server in data
            servers << server.reject { |key, value| !['id', 'name', 'links'].include?(key) }
          end
          response.status = [200, 203][rand(1)]
          response.body = { 'servers' => servers }
          response
        end

      end
    end
  end
end
