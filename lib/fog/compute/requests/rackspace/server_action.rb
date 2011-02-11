module Fog
  module Rackspace
    class Compute
      class Real

        # Reboot an existing server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to reboot
        # * body<~.to_json object> - Body of the request, describes the action (see reboot_server as an example)
        # * expect<~Integer> - expected return, 202 except for confirm resize (204)
        #
        def server_action(server_id, body, expects=202)
          request(
            :body     => body.to_json,
            :expects  => expects,
            :method   => 'POST',
            :path     => "servers/#{server_id}/action.json"
          )
        end

      end
    end
  end
end
