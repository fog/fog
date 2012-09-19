module Fog
  module BareMetalCloud
    class LoadBalancing
      class Real

        # List existing farms
        #
        # ==== Parameters
        # * options<~Hash>: Optional or Required arguments
        #   * no parameters are required
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'farm'<~Array>
        #       * 'id'<~String>   - Id of the plan
        #       * 'name'<~String>   - Name of the plan
        #       * 'method'<~String>   - Load Balancing algorithm to use 
        #       * 'address'<~String>    - Farm IP address
        #       * 'port'<~String>   - Service port number
        #       * 'service'<~String> - Connection type (http, https, dns, ftp, ntp, pop3, smtp)
        #
        def list_farms(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/listFarms',
            :query    => options
          )
        end

      end
    end
  end
end
