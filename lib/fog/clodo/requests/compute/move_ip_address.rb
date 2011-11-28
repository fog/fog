module Fog
  module Compute
    class Clodo
      class Real

        # Move IP-address to specified server.
        # ==== Paramaters
        # * server_id<~Integer> - Id of server to move IP to
        # * ip<~String> - IP-address to move
        #
        # ==== Returns
        # * response<~Excon::Response>
        #

        def move_ip_address(server_id, ip)
          request(
                  :expects  => [204],
                  :method   => 'GET',
                  :path     => "servers/#{server_id}/ips/moveip",
                  :body     => MultiJson.encode({'ip'=>"#{ip}"})
                  )
        end
      end

      class Mock
        def move_ip_address(server_id, ip)
          response = Excon::Response.new
          response.status = [204]
          response
        end
      end
    end
  end
end
