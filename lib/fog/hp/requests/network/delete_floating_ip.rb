module Fog
  module HP
    class Network
      class Real
        # Delete an existing floating ip
        #
        # ==== Parameters
        #   * 'floating_ip_id'<~String>: - UUId of the floating IP address to delete
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
          if list_floating_ips.body['floatingips'].find {|_| _['id'] == floating_ip_id}
            self.data[:floating_ips].delete(floating_ip_id)
            response.status = 204
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
