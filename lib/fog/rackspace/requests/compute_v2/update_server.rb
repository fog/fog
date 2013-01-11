module Fog
  module Compute
    class RackspaceV2
      class Real
        def update_server(server_id, name)
          data = {
            'server' => {
              'name' => name
            }
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => [200],
            :method => 'PUT',
            :path => "servers/#{server_id}"
          )
        end
      end

      class Mock
        def update_server(server_id, name)
          server          = self.data[:servers][server_id]
          server['name']  = name
          server_response = Fog::Rackspace.keep(server, 'id', 'name', 'hostId', 'created', 'updated', 'status', 'progress', 'user_id', 'tenant_id', 'links', 'metadata', 'accessIPv4', 'accessIPv6', 'OS-DCF:diskConfig', 'rax-bandwidth:bandwidth', 'addresses', 'flavor', 'links', 'image')

          response(
            :status => 200,
            :body   => {'server' => server_response}
          )
        end
      end
    end
  end
end
