module Fog
  module Compute
    class BareMetalCloud
      class Real

        # Reboot a running server
        #
        # ==== Parameters
        # * serverId<~String> - The id of the server to reboot
        #
        def reboot_server(server_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/rebootServer',
            :query    => {'serverId' => server_id}
          )
        end

      end
    end
  end
end
