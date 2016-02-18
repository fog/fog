module Fog
  module Network
    class OpenStack
      class Real
        def disassociate_floating_ip(floating_ip_id, options = {})
          data = {
            'floatingip' => {
              'port_id'    => nil,
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
        def disassociate_floating_ip(floating_ip_id, options = {})
          if data = self.data[:floating_ips][floating_ip_id]
            response = Excon::Response.new
            response.status = 201
            data['port_id'] = nil
            data['fixed_ip_address'] = nil
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
