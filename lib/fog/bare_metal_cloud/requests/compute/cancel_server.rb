module Fog
  module Compute
    class BareMetalCloud
      class Real

        # Shutdown a running server
        #
        # ==== Parameters
        # * options<~Hash>: Optional or Required arguments
        #   * serverId<~String> - The id of the server to be cancelled
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'server'<~Hash>:
        #       * 'id'<~String> - Id of the image
        #
        def cancel_server(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/cancelServer',
            :query    => options
          )
        end

      end
    end
  end
end
