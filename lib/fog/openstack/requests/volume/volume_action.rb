module Fog
  module Volume
    class OpenStack
      class Real
        def volume_action(volume_id, action, params)
          data = {
            "os-#{action}" => params
          }

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => "volumes/#{volume_id}/action"
          )
        end
      end

      class Mock
        def volume_action(volume_id, action, params)
          response = Excon::Response.new
          response.status = 202
          response
        end
      end
    end
  end
end
