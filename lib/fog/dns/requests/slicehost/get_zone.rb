module Fog
  module Slicehost
    class DNS
      class Real

        require 'fog/dns/parsers/slicehost/get_zone'

        # Get details of a DNS zone
        #
        # ==== Parameters
        # * zone_id<~Integer> - Id of zone to lookup
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'origin'<~String> - domain name to host (ie example.com)
        #     * 'id'<~Integer> - Id of the zone
        #     * 'ttl'<~Integer> - TimeToLive (ttl) for the domain, in seconds (> 60)
        #     * 'active'<~String> - whether zone is active in Slicehost DNS server - 'Y' or 'N'
        def get_zone(zone_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Slicehost::DNS::GetZone.new,
            :path     => "/zones/#{zone_id}.xml"
          )
        end

      end
    end
  end
end
