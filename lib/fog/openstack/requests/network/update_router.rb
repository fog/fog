module Fog
  module Network
    class OpenStack

      class Real
        
        # Updates a logical router
        #
        # Beyond the name and the administrative state, the only 
        # parameter which can be updated with this operation is 
        # the external gateway.
        #
        # @see http://docs.openstack.org/api/openstack-network/2.0/content/router_update.html
        def update_router(router_id, options = {})
          data = { 'router' => {} }

          vanilla_options = [:name, :external_gateway_info, :admin_state_up] 
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
          # FIXME
          response = Excon::Response.new
          if router = list_routers.body['routers'].detect { |_| _['id'] == router_id }
            router['name']           = options[:name]
            router['fixed_ips']      = options[:fixed_ips]
            router['admin_state_up'] = options[:admin_state_up]
            router['device_owner']   = options[:device_owner]
            router['device_id']      = options[:device_id]
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
