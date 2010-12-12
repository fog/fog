module Fog
  module Zerigo
    class Compute
      class Real

        require 'fog/zerigo/parsers/compute/list_zones'

        # Get list of all DNS zones hosted on Slicehost (for this account)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'origin'<~String> - domain name to host (ie example.com)
        #     * 'id'<~Integer> - Id of the zone
        #     * 'ttl'<~Integer> - TimeToLive (ttl) for the domain, in seconds (> 60)
        #     * 'active'<~String> - whether zone is active in Slicehost DNS server - 'Y' or 'N'
        def list_zones
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Zerigo::Compute::ListZones.new,
            :path     => '/api/1.1/zones.xml'
          )
        end

      end

      class Mock

        def list_zones
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
