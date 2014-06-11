module Fog
  module Compute
    class HPV2
      class Real
        # Associate a floating IP address with an existing server
        #
        # Note: This method will proxy the call to the Network (Quantum) service,
        # to associate the IP address with the first network available.
        # If the network is not routable, it will throw an exception.
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to associate IP with
        # * 'ip_address'<~String> - IP address to associate with the server
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
            if server['addresses']['custom']
              server['addresses']['custom'] << data
            else
              server['addresses']['custom'] = data
            end
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
