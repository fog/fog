unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # Reboot an existing server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to reboot
        # * type<~String> - Type of reboot, must be in ['HARD', 'SOFT']
        #
        def reboot_server(server_id, type)
          data = {
            'reboot' => { 'type' => type }
          }
          request(
            :body     => data.to_json,
            :expects  => 202,
            :method   => 'POST',
            :path     => "servers/#{id}"
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def update_server
        end

      end
    end
  end

end
