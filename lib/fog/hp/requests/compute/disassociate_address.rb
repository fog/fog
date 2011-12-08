module Fog
  module Compute
    class HP
      class Real

        # Disassociate a floating IP address with existing server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to associate IP with
        # * ip_address<~String> - IP address to associate with the server
        #
        def disassociate_address(server_id, ip_address)
          body = { 'removeFloatingIp' => { 'server' => server_id, 'address' => ip_address }}
          server_action(server_id, body)
        end

      end

      class Mock

        def disassociate_address(server_id, ip_address)
          response = Excon::Response.new
          response.status = 202
          response
        end

      end
    end
  end
end
