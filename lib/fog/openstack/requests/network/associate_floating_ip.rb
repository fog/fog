module Fog
  module Network
    class OpenStack
      class Real
        def associate_floating_ip(floating_ip_id, port_id, options = {})
          data = {
            'floatingip' => {
              'port_id'    => port_id,
            }
          }

          vanilla_options = [:fixed_ip_address]
          vanilla_options.reject{ |o| options[o].nil? }.each do |key|
            data['floatingip'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [200],
            :method   => 'PUT',
            :path     => "floatingips/#{floating_ip_id}"
          )
        end
      end

      class Mock
        def associate_floating_ip(floating_ip_id, port_id, options = {})
          if data = self.data[:floating_ips][floating_ip_id]
            response = Excon::Response.new
            response.status = 201
            data['port_id'] = port_id
            data['fixed_ip_address'] = options[:fixed_ip_address]
            response.body = { 'floatingip' => data }
            response
          else
            raise Fog::Network::OpenStack::NotFound
          end
        end
      end
    end
  end
end
