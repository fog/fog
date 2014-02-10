module Fog
  module Compute
    class Rackspace
      class Real

        # Reboot an existing server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to reboot
        # * type<~String> - Type of reboot, must be in ['HARD', 'SOFT']
        #
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
