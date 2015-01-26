module Fog
  module Compute
    class HPV2
      class Real
        # Reboot an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to reboot
        # * 'type'<~String> - Type of reboot, must be in ['HARD', 'SOFT']
        def reboot_server(server_id, type = 'SOFT')
          body = { 'reboot' => { 'type' => type }}
          server_action(server_id, body)
        end
      end

      class Mock
        def reboot_server(server_id, type = 'SOFT')
          response = Excon::Response.new
          if list_servers_detail.body['servers'].find {|_| _['id'] == server_id}
            self.data[:servers][server_id]['status'] = (type == 'SOFT') ? 'REBOOT' : 'HARD_REBOOT'
            response.status = 202
            response
          else
            raise Fog::Compute::HPV2::NotFound
          end
        end
      end
    end
  end
end
