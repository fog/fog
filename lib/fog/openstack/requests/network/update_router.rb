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
          vanilla_options = [:name, :admin_state_up, :tenand_id]
          vanilla_options.select{ |o| options.has_key?(o) }.each do |key|
            data['router'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "routers/#{router_id}.json"
          )
        end
      end

      class Mock
        def update_router(router_id, options = {})
          response = Excon::Response.new
          if router = list_routers.body['routers'].detect { |_| _['id'] == router_id }
            router['name']           = options[:name]
            router['admin_state_up'] = options[:admin_state_up]
            router['tenant_id']      = options[:tenant_id]
            response.body = { 'router' => router }
            response.status = 200
            response
          else
            raise Fog::Network::OpenStack::NotFound
          end
        end
      end

    end
  end
end
