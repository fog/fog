module Fog
  module Compute
    class RackspaceV2
      class Real
        
        # Reboots server
        # @param [String] server_id
        # @param [String<SOFT,HARD>] type type of reboot
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Reboot_Server-d1e3371.html
        def reboot_server(server_id, type)
          data = {
            'reboot' => {
              'type' => type
            }
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => [202],
            :method => 'POST',
            :path => "servers/#{server_id}/action"
          )
        end
      end

      class Mock
        def reboot_server(server_id, type)
          body = {
            "reboot" => {
              "type" => type.upcase
            }
          }
          response(
            :body => body,
            :status => 202
          )
        end
      end
    end
  end
end
