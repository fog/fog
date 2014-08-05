module Fog
  module Compute
    class BareMetalCloud
      class Real
        # Boot a new server by configuration
        #
        # ==== Parameters
        # * config<~String> - The Hardware configuration string
        # * options<~Hash>: optional extra arguments
        #   * imageName<~String>  - Optional imageName to be installed
        #   * name<~String>     - Optional server Name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'server'<~Hash>:
        #       * 'id'<~String> - Id of the image
        #
        def add_server_by_configuration(config, options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/addServerByConfiguration',
            :query    => {'configuration' => config}.merge!(options)
          )
        end
      end
    end
  end
end
