module Fog
  module BareMetalCloud
    class LoadBalancing
      class Real

        # Add a farm
        #
        # ==== Parameters
        # * options<~Hash>: Optional or Required arguments
        #       * 'name'<~String>   - Name of the farm
        #       * 'method'<~String>   - Load Balancing algorithm to use 
        #       * 'service'<~String> - Connection type (http, https, dns, ftp, ntp, pop3, smtp)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'add-farm-response'<~String> - Empty string
        #
        def add_farm(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/addFarm',
            :query    => options
          )
        end

      end
    end
  end
end
