module Fog
  module Network
    class OpenStack

      class Real
        def disassociate_floatingip(floatingip_id, options = {})
          data = {
            'floatingip' => {
              'floatingip_id' => floatingip_id,
            }
          }

          # vanilla_options = [:port_id, :tenant_id, :fixed_ip_address ]
          # vanilla_options.reject{ |o| options[o].nil? }.each do |key|
          #   data['floatingip'][key] = options[key]
          # end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [201],
            :method   => 'POST',
            :path     => 'floatingips'
          )
        end
      end

      class Mock
        def disassociate_floatingip(floatingip_id, options = {})
          response = Excon::Response.new
          if list_floatingips.body['floatingips'].map { |r| r['id'] }.include? floatingip_id
            self.data[:floatingips].delete(floatingip_id)
            response.status = 204
            response
          else
            raise Fog::Network::OpenStack::NotFound
          end
        end
      end

    end
  end
end
