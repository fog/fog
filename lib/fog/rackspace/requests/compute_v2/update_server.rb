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
    end
  end
end
