module Fog
  module Compute
    class HPV2
      class Real
        # Server actions for an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to reboot
        # * 'body'<~.to_json object> - Body of the request, describes the action (see reboot_server as an example)
        # * 'expect'<~Integer> - expected return, 202 except for confirm resize (204)
        #
        def server_action(server_id, body, expects=202)
          request(
            :body     => Fog::JSON.encode(body),
            :expects  => expects,
            :method   => 'POST',
            :path     => "servers/#{server_id}/action"
          )
        end
      end
    end
  end
end
