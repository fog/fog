module Fog
  module BareMetalCloud
    class LoadBalancing
      class Real

        # Remove a server from an existing farm
        #
        # ==== Parameters
        # * options<~Hash>: Optional or Required arguments
        #   * farmId<~String>   - Id of the farm
        #   * serverId<~String>   - Id of the server
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'remove-from-farm-response'<~String> - Empty reponse
        #
        def remove_from_farm(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/removeFromFarm',
            :query    => options
          )
        end

      end
    end
  end
end
