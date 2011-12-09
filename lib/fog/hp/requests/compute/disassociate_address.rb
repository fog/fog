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
          if server = self.data[:servers][server_id]
            data = server['addresses']['novanet_7'].reject {|a| a['addr'] == ip_address}
            self.data[:servers][server_id]['addresses']['novanet_7'] = data
          else
            raise Fog::Compute::HP::Error.new("InvalidServer.NotFound => The server '#{server_id}' does not exist.")
          end

          response.status = 202
          response
        end

      end
    end
  end
end
