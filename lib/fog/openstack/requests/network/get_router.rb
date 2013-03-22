module Fog
  module Network
    class OpenStack

      class Real
        def get_router(router_id)
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "routers/#{router_id}"
          )
        end
      end

      class Mock
        def get_router(router_id)
          response = Excon::Response.new
          if data = (self.data['routers'].find { |r| r['id'] == router_id })
            response.status = 200
            response.body = {
              'router' => {
                'status' => 'ACTIVE',
                'external_gateway_info' => {
                  'network_id' => '3c5bcddd-6af9-4e6b-9c3e-c153e521cab8'
                },
                'name' => 'router1',
                'admin_state_up' => true,
                'tenant_id' => '33a40233088643acb66ff6eb0ebea679',
                'id' => 'a9254bdb-2613-4a13-ac4c-adc581fba50d'
              }
            }
            response
          else
            raise Fog::Network::OpenStack::NotFound
          end
        end
      end

    end
  end
end
