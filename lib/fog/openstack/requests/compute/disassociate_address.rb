module Fog
  module Compute
    class OpenStack
      class Real

        def disassociate_address(server_id, ip_address)

          body = { 'removeFloatingIp' => { 'server' => server_id, 'address' => ip_address }}

          request(
            :body     => MultiJson.encode(body),
            :expects  => 202,
            :method   => 'POST',
            :path     => "servers/#{server_id}/action.json"
          )


        end

      end

      class Mock
        def disassociate_address(server_id, ip_address)
          response = Excon::Response.new
          response.status = 202
          response.headers = {
            "Content-Type" => "text/html, charset=UTF-8",
            "Content-Length" => "0",
            "Date"=> Date.new
          }
          response
        end
      end
    end
  end
end
