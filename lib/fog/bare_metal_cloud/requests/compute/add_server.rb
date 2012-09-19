module Fog
  module Compute
    class BareMetalCloud
      class Real

        # Boot a new server
        #
        # ==== Parameters
        # * options<~Hash>: Optional or Required arguments
        #   * planId<~String> - The id of the plan to boot the server with
        #   * imageId<~String>  - Optional image to boot server from
        #   * name<~String>     - Name to boot new server with
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'server'<~Hash>:
        #       * 'id'<~String> - Id of the image
        #
        def add_server(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/addServer',
            :query    => options
          )
        end

      end
    end
  end
end
