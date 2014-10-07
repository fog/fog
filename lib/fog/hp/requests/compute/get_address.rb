module Fog
  module Compute
    class HP
      class Real
        # Get details about an existing floating IP address
        #
        # ==== Parameters
        # * 'address_id'<~Integer> - Id of floating IP address get details for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'floating_ip'<~Hash> -
        #       * 'id'<~Integer> - Id of the address
        #       * 'ip'<~String> - Floating IP of the address
        #       * 'instance_id'<~String> - Id of the associated server instance
        #       * 'fixed_ip'<~String> - Fixed IP of the address
        def get_address(address_id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "os-floating-ips/#{address_id}"
          )
        end
      end

      class Mock
        def get_address(address_id)
          response = Excon::Response.new
          if address = self.data[:addresses][address_id]
            response.status = 200
            response.body = { 'floating_ip' => address }
            response
          else
            raise Fog::Compute::HP::NotFound
          end
        end
      end
    end
  end
end
