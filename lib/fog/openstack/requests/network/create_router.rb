module Fog
  module Network
    class OpenStack

      class Real
        def create_router(name, options = {})
          data = {
            'router' => {
              'name' => name,
            }
          }

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [201],
            :method   => 'POST',
            :path     => 'routers'
          )
        end
      end

      class Mock
        def create_router(name, options = {})
          response = Excon::Response.new
          response.status = 201
          data = {
            'router' => {
              'status' => 'ACTIVE',
              'external_gateway_info' => null,
              'name' => 'another_router',
              'admin_state_up' => true,
              'tenant_id' => '6b96ff0cb17a4b859e1e575d221683d3',
              'id' => '8604a0de-7f6b-409a-a47c-a1cc7bc77b2e'
            }
          }
          self.data[:routers][data['id']] = data
          response.body = { 'router' => data }
          response
        end
      end

    end
  end
end
