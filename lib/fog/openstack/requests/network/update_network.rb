module Fog
  module Network
    class OpenStack
      class Real
        def update_network(network_id, options = {})
          data = { 'network' => {} }

          vanilla_options = [:name, :shared, :admin_state_up]
          vanilla_options.select{ |o| options.key?(o) }.each do |key|
            data['network'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "networks/#{network_id}.json"
          )
        end
      end

      class Mock
        def update_network(network_id, options = {})
          response = Excon::Response.new
          if network = list_networks.body['networks'].find { |_| _['id'] == network_id }
            network['name']           = options[:name]
            network['shared']         = options[:shared]
            network['admin_state_up'] = options[:admin_state_up]
            response.body = { 'network' => network }
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
