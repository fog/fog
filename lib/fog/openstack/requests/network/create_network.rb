module Fog
  module Network
    class OpenStack

      class Real
        def create_network(options = {})
          data = { 'network' => {} }

          vanilla_options = [:name, :shared, :admin_state_up, :tenant_id]
          vanilla_options.reject{ |o| options[o].nil? }.each do |key|
            data['network'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [201],
            :method   => 'POST',
            :path     => 'networks'
          )
        end
      end

      class Mock
        def create_network(options = {})
          response = Excon::Response.new
          response.status = 201
          data = {
            'id'             => Fog::Mock.random_numbers(6).to_s,
            'name'           => options[:name],
            'shared'         => options[:shared],
            'subnets'        => [],
            'status'         => 'ACTIVE',
            'admin_state_up' => options[:admin_state_up],
            'tenant_id'      => options[:tenant_id],
          }
          self.data[:networks][data['id']] = data
          response.body = { 'network' => data }
          response
        end
      end

    end
  end
end