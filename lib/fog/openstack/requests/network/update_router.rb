module Fog
  module Network
    class OpenStack

      class Real
        def update_router(router_id, network_id, options = {})
          data = { 
           'router' => {
              'external_gateway_info' => {
                'network_id' => network_id,
              }
            }
          }

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "routers/#{router_id}.json"
          )
        end
      end

      class Mock
        def update_router(router_id, network_id, options = {})
          response = Excon::Response.new
          response.status = 201
          data = {
            'status' => 'ACTIVE',
            'external_gateway_info' => {
              'network_id' => '8ca37218-28ff-41cb-9b10-039601ea7e6b'
            },
            'name' => 'another_router',
            'admin_state_up' => true,
            'tenant_id' => '6b96ff0cb17a4b859e1e575d221683d3',
            'id' => '8604a0de-7f6b-409a-a47c-a1cc7bc77b2e'
          }
          self.data[:router_id][data['router_id']] = data
          response.body = { 'router' => data }
          response
        end
      end

    end
  end
end
