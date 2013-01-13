module Fog
  module Network
    class OpenStack

      class Real
        def delete_floating_ip(floating_ip_id)
          request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "floatingips/#{floating_ip_id}"
          )
        end
      end

      class Mock
        def delete_floating_ip(floating_ip_id)
          response = Excon::Response.new
          if list_floating_ips.body['floating_ips'].map { |r| r['id'] }.include? floating_ip_id
            self.data[:floating_ips].delete(floating_ip_id)
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
