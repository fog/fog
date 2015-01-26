module Fog
  module Network
    class OpenStack
      class Real
        # Update Router
        #
        # Beyond the name and the administrative state, the only
        # parameter which can be updated with this operation is
        # the external gateway.
        # @see http://docs.openstack.org/api/openstack-network/2.0/content/router_update.html
        def update_router(router_id, options = {})
          data = { 'router' => {} }

          [:name, :admin_state_up].each do |key|
            data['router'][key] = options[key] if options[key]
          end

          # remove this in a future
          egi = options[:external_gateway_info]
          if egi
            if egi.is_a?(Fog::Network::OpenStack::Network)
              Fog::Logger.deprecation "Passing a model objects into options[:external_gateway_info] is deprecated. \
              Please pass  external external gateway as follows options[:external_gateway_info] = { :network_id => NETWORK_ID }]"
              data['router'][:external_gateway_info] = { :network_id => egi.id }
            elsif egi.is_a?(Hash) and egi[:network_id]
              data['router'][:external_gateway_info] = egi
            else
              raise ArgumentError.new('Invalid external_gateway_info attribute')
            end
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
          router = list_routers.body['routers'].find {|r| r[:id] == router_id}

          raise Fog::Network::OpenStack::NotFound unless router

          options.keys.each {|k| router[k] = options[k] }

          # remove this in a future
          egi = options[:external_gateway_info]
          if egi
            if egi.is_a?(Fog::Network::OpenStack::Network)
              Fog::Logger.deprecation "Passing a model objects into options[:external_gateway_info] is deprecated. \
              Please pass  external external gateway as follows options[:external_gateway_info] = { :network_id => NETWORK_ID }]"
              router[:external_gateway_info] = { :network_id => egi.id }
            else egi.is_a?(Hash) && egi[:network_id]
              router[:external_gateway_info] = egi
            end
          end

          response.body = { 'router' => router }
          response.status = 200
          response
        end
      end
    end
  end
end
