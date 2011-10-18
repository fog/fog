module Fog
  module Compute
    class OpenStack
      class Real

        def reboot_server(server_id, type = 'SOFT')
          body = { 'reboot' => { 'type' => type }}
          server_action(server_id, body)
        end

      end

      class Mock

        def reboot_server(server_id, type = 'SOFT')
          response = Excon::Response.new
          response.status = 202
          response
        end

      end
    end
  end
end
