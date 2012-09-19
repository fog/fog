module Fog
  module Compute
    class BareMetalCloud
      class Real

        # List Configurations
        #
        # ==== Parameters
        # * options<~Hash>: Optional or Required arguments
        #   * no parameters are required
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * available-server<~Array>:
        #       * 'configuration'<~String>     - Hardware Configuration string
        #       * 'quantity'<~String>:  - quantity of servers to a certain configuration
        #
        def list_configurations(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/listConfigurations',
            :query    => options
          )
        end

      end
    end
  end
end
