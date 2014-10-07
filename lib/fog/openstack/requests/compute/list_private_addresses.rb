module Fog
  module Compute
    class OpenStack
      class Real
        def list_private_addresses(server_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "servers/#{server_id}/ips/private.json"
          )
        end
      end

      class Mock
        def list_private_addresses(server_id)
          response = Excon::Response.new
          if server = list_servers_detail.body['servers'].find {|_| _['id'] == server_id}
            response.status = [200, 203][rand(1)]
            response.body = { 'private' => server['addresses']['private'] }
            response
          else
            raise Fog::Compute::OpenStack::NotFound
          end
        end
      end
    end
  end
end
