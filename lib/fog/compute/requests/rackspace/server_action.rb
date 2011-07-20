module Fog
  module Compute
    class Rackspace
      class Real

        # Reboot an existing server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to reboot
        # * body<~String> - Body of the request, describes the action (see reboot_server as an example)
        # * expect<~Integer> - expected return, 202 except for confirm resize (204)
        #
        def server_action(server_id, body, expects=202)
          request(
            :body     => MultiJson.encode(body),
            :expects  => expects,
            :method   => 'POST',
            :path     => "servers/#{server_id}/action.json"
          )
        end

      end
    end
  end
end
