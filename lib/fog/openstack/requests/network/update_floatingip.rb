module Fog
  module Network
    class OpenStack

      class Real
        def update_floatingip(floating_network_id, options = {})
          data = { 'floatingip' => {} }

          vanilla_options = [:port_id, :tenant_id, :fixed_ip_address ]
          vanilla_options.select{ |o| options.has_key?(o) }.each do |key|
            data['floatingip'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "floatingips/#{floating_network_id}"
          )
        end
      end

      class Mock
        def update_floatingip(floating_network_id, options = {})
          response = Excon::Response.new
          if floatingip = list_floatingips.body['floatingips'].detect { |_| _['id'] == floating_network_id }
            floatingip['port_id']         = options[:port_id]
            floatingip['tenant_id']      = options[:tenant_id]
            floatingip['fixed_ip_address'] = options[:fixed_ip_address]
            response.body = { 'floatingip' => floatingip }
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
