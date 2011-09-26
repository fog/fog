module Fog
  module Compute
    class OpenStack
      class Real

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
