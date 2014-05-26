module Fog
  module Compute
    class HP
      class Real
        # Associate a floating IP address with existing server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to associate IP with
        # * ip_address<~String> - IP address to associate with the server
        #
        def associate_address(server_id, ip_address)
          body = { 'addFloatingIp' => { 'server' => server_id, 'address' => ip_address }}
          server_action(server_id, body)
        end
      end

      class Mock
        def associate_address(server_id, ip_address)
          response = Excon::Response.new
          if server = self.data[:servers][server_id]
            data = {"version"=>4, "addr"=>"#{ip_address}"}
            if server['addresses']['private']
              server['addresses']['private'] << data
            else
              server['addresses']['private'] = data
            end
            response.status = 202
          else
            #raise Fog::Compute::HP::NotFound
            response.status = 500
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end
      end
    end
  end
end
