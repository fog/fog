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
        def reboot_server(server_id, type = 'SOFT')
          request(
            :body     => { 'reboot' => { 'type' => type }}.to_json,
            :expects  => 202,
            :method   => 'POST',
            :path     => "servers/#{server_id}/action.json"
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def reboot_server(server_id, type)
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end

end
