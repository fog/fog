module Fog
  module BareMetalCloud
    class LoadBalancing
      class Real

        # Cancel an existing farm
        #
        # ==== Parameters
        # * options<~Hash>: Optional or Required arguments
        #   * farmId<~String>   - Id of the farm
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'cancel-farm-response'<~String>    - Empty string
        #
        def cancel_farm(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/cancelFarm',
            :query    => options
          )
        end

      end
    end
  end
end
