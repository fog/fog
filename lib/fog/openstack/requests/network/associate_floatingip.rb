module Fog
  module Network
    class OpenStack

      class Real
        def associate_floatingip(floating_network_id, options = {})
          data = {
            'floatingip' => {
              'network_id' => floating_network_id,
            }
          }

          vanilla_options = [:port_id, :fixed_ip_address ]
          vanilla_options.reject{ |o| options[o].nil? }.each do |key|
            data['floatingip'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [201],
            :method   => 'POST',
            :path     => 'floatingips'
          )
        end
      end

      class Mock
        def associatee_floatingip(floating_network_id, options = {})
          response = Excon::Response.new
          response.status = 201
          data = {
            'id' => '00000000-0000-0000-0000-000000000000',
          }
          self.data[:floatingips][data['id']] = data
          response.body = { 'floatingip' => data }
          response
        end
      end

    end
  end
end
