module Fog
  module Network
    class OpenStack

      class Real
        def delete_floatingip(floating_network_id)
          request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "floatingips/#{floating_network_id}"
          )
        end
      end

      class Mock
        def delete_floatingip(floating_network_id)
          response = Excon::Response.new
          if list_floatingips.body['floatingips'].map { |r| r['id'] }.include? floating_network_id
            self.data[:floatingips].delete(floating_network_id)
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
