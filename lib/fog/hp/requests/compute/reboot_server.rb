module Fog
  module Compute
    class HP
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
          if list_servers_detail.body['servers'].find {|_| _['id'] == server_id}
            response.status = 202
            response
          else
            raise Fog::Compute::HP::NotFound
          end
        end
      end
    end
  end
end
