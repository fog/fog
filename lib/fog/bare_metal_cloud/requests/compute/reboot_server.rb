module Fog
  module Compute
    class BareMetalCloud
      class Real

        # Reboot a running server
        #
        # ==== Parameters
        # * options<~Hash>: Optional or Required arguments
        #   * serverId<~String> - The id of the server to reboot
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'reboot-server-response'<~String>    - Empty string
        #
        def reboot_server(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/rebootServer',
            :query    => options
          )
        end

      end
    end
  end
end
