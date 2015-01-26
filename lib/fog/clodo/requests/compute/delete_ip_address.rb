module Fog
  module Compute
    class Clodo
      class Real
        # Delete IP-address from specified server
        # ==== Paramaters
        # * server_id<~Integer> - Id of server to delete IP from
        # * ip<~String> - IP-address to delete
        #
        # ==== Returns
        # * response<~Excon::Response>
        #

        def delete_ip_address(server_id, ip)
          data = {'ip' => ip}

          request(
                  :expects  => [204],
                  :method   => 'DELETE',
                  :path     => "servers/#{server_id}/ips",
                  :body     => Fog::JSON.encode(data)
                  )
        end
      end

      class Mock
        def delete_ip_address(server_id, ip)
          server = self.data[:servers][server_id]

          raise Excon::Errors::BadRequest.new "Server not found" unless server

          pa = server['addresses']['public']

          raise Excon::Errors::BadRequest.new "Address not found" unless pa && pa.reject! {|addr|
            addr['ip'] == ip
          }

          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
