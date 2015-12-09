module Fog
  module Compute
    class RackspaceV2
      class Real
        # Get a vnc console for an instance.
        #
        # === Parameters
        # * server_id <~String> - The ID of the server.
        # * console_type <~String> - Type of vnc console to get ('novnc' or 'xvpvnc').
        # === Returns
        # * response <~Excon::Response>:
        #   * body <~Hash>:
        #     * url <~String>
        #     * type <~String>
        def get_vnc_console(server_id, console_type)
          data = {
            'os-getVNCConsole' => {
              'type' => console_type
            }
          }
          request(
            :body => Fog::JSON.encode(data),
            :expects => [200],
            :method => 'POST',
            :path => "servers/#{server_id}/action"
          )
        end # def get_vnc_console
      end # class Real

      class Mock
        def get_vnc_console(server_id, console_type)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "console" => {
              "url"  => "http://192.168.27.100:6080/vnc_auto.html?token=c3606020-d1b7-445d-a88f-f7af48dd6a20",
              "type" => "novnc"
            }
          }
          response
        end # def get_vnc_console
      end # class Mock
    end # class OpenStack
  end # module Compute
end # module Fog
