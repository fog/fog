module Fog
  module Network
    class OpenStack
      class Real
        def get_network(network_id)
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "networks/#{network_id}"
          )
        end
      end

      class Mock
        def get_network(network_id)
          response = Excon::Response.new
          if data = self.data[:networks][network_id]
            response.status = 200
            response.body = {
              'network' => {
                'id' => 'e624a36d-762b-481f-9b50-4154ceb78bbb',
                'name' => 'network_1',
                'subnets' => [
                  '2e4ec6a4-0150-47f5-8523-e899ac03026e'
                ],
                'shared' => false,
                'status' => 'ACTIVE',
                'admin_state_up' => true,
                'tenant_id' => 'f8b26a6032bc47718a7702233ac708b9',
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
