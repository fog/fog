module Fog
  module Compute
    class HPV2
      class Real
        # Retrieve VNC console for the specified instance
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of instance to get console output from
        # * 'type'<~String> - Type of the vnc console, defaults to 'novnc'
        # ==== Returns
        # # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'console'
        #       * 'type'<~String> - Type of the vnc console
        #       * 'url'<~String> - Url to access a VNC console of a server from a browser
        #
        def get_vnc_console(server_id, type='novnc')
          body = { 'os-getVNCConsole' => { 'type' => type }}
          server_action(server_id, body, 200)
        end
      end

      class Mock
        def get_vnc_console(server_id, type='novnc')
          output = {
              'type' => type,
              'url'  => 'https://region.compute.hpcloud.com/vnc_auto.html?token=123ABX234'
          }
          response = Excon::Response.new
          if list_servers_detail.body['servers'].find {|_| _['id'] == server_id}
            response.body = { 'console' => output }
            response.status = 200
          else
            raise Fog::Compute::HPV2::NotFound
          end
          response
        end
      end
    end
  end
end
