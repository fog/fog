module Fog
  module BareMetalCloud
    class LoadBalancing
      class Real

        # Add server to an existing farm
        #
        # ==== Parameters
        # * options<~Hash>: Optional or Required arguments
        #   * farmId<~String>   - Id of the farm
        #   * serverId<~String>   - Id of the server
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'add-to-farm-response'<~String> - Empty reponse
        #
        def add_to_farm(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/addToFarm',
            :query    => options
          )
        end

      end
    end
  end
end
