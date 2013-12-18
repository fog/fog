module Fog
  module Compute
    class BareMetalCloud
      class Real

        # Boot a new server by configuration
        #
        # ==== Parameters
        # * options<~Hash>: Optional or Required arguments
        #   * config<~String> - The Hardware configuration string
        #   * imageName<~String>  - Optional imageName to be installed
        #   * name<~String>     - Optional server Name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'server'<~Hash>:
        #       * 'id'<~String> - Id of the image
        #
        def add_server_by_configuration(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/addServerByConfiguration',
            :query    => options
          )
        end

      end
    end
  end
end
