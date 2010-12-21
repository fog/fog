module Fog
  module Slicehost
    class Compute
      class Real

        require 'fog/slicehost/parsers/compute/get_zones'

        # Get list of all DNS zones hosted on Slicehost (for this account)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'zones'<~Array>
        #       * 'origin'<~String> - domain name to host (ie example.com)
        #       * 'id'<~Integer> - Id of the zone
        #       * 'ttl'<~Integer> - TimeToLive (ttl) for the domain, in seconds (> 60)
        #       * 'active'<~String> - whether zone is active in Slicehost DNS server - 'Y' or 'N'
        def get_zones
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Slicehost::Compute::GetZones.new,
            :path     => 'zones.xml'
          )
        end

      end

      class Mock

        def get_zones
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
