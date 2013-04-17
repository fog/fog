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

          vanilla_options = [
            :admin_state_up, 
            :tenant_id,
            :network_id,
            :external_gateway_info,
            :status,
            :subnet_id
          ]

          vanilla_options.reject{ |o| options[o].nil? }.each do |key|
            data['router'][key] = options[key]
          end

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
              'id'     => Fog::Mock.random_numbers(6).to_s,
              'status' => options[:status] || 'ACTIVE',
              'external_gateway_info' => options[:external_gateway_info],
              'name' => name,
              'admin_state_up' => options[:admin_state_up],
              'tenant_id' => '6b96ff0cb17a4b859e1e575d221683d3'
            }
          }
          self.data[:routers][data['router']['id']] = data['router']
          response.body = data
          response
        end
      end

    end
  end
end
