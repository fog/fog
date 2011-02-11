module Fog
  module Slicehost
    class DNS
      class Real

        require 'fog/dns/parsers/slicehost/get_zones'

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
            :parser   => Fog::Parsers::Slicehost::DNS::GetZones.new,
            :path     => 'zones.xml'
          )
        end

      end
    end
  end
end
