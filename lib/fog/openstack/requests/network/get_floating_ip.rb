module Fog
  module Network
    class OpenStack
      class Real
        def get_floating_ip(floating_ip_id)
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "floatingips/#{floating_ip_id}"
          )
        end
      end

      class Mock
        def get_floating_ip(floating_ip_id)
          response = Excon::Response.new

          if data = self.data[:floating_ips][floating_ip_id]
            response.status = 200
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
