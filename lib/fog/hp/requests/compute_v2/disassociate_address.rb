module Fog
  module Compute
    class HPV2
      class Real
        # Disassociate a floating IP address with an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to associate IP address with
        # * 'ip_address'<~String> - IP address to associate with the server
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
            data = server['addresses']['custom'].reject {|a| a['addr'] == ip_address}
            self.data[:servers][server_id]['addresses']['custom'] = data

            response.status = 202
          else
            #raise Fog::Compute::HPV2::NotFound
            response.status = 500
            raise(Excon::Errors.status_error({:expects => 202}, response))
          end
          response
        end
      end
    end
  end
end
