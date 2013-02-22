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

          vanilla_options = [:admin_state_up, :tenand_id]
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
            'id'             => Fog::Mock.random_numbers(6).to_s,
            'name'           => options[:name],
            'status'         => 'ACTIVE',
            'admin_state_up' => options[:admin_state_up],
            'tenant_id'      => options[:tenant_id],
          }
          self.data[:routers][data['id']] = data
          response.body = { 'router' => data }
          response
        end
      end

    end
  end
end
