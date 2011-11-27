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

        def move_ip(server_id, ip)
          request(
                  :expects  => [200, 203],
                  :method   => 'GET',
                  :path     => "servers/#{server_id}/ips/moveip/#{ip}"
                  )
        end
      end

      class Mock
        def move_ip(server_id, ip)
          response = Excon::Response.new
          response.status = [200, 203][rand(1)]
          response
        end
      end
    end
  end
end
