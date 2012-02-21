module Fog
  module Compute
    class OpenStack
      class Real

        def associate_address(server_id, ip_address)
          body = { 'addFloatingIp' => { 'server' => server_id, 'address' => ip_address }}

          request(
            :body     => MultiJson.encode(body),
            :expects  => 202,
            :method   => 'POST',
            :path     => "servers/#{server_id}/action.json"
          )

        end

      end

      class Mock



      end
    end
  end
end
