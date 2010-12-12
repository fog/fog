module Fog
  module Zerigo
    class Compute
      class Real

        require 'fog/zerigo/parsers/compute/get_zone'

        # Get details of a DNS zone. This response is similar to list_zones, with the 
        # addition of hosts-count and possibly hosts.
        #
        # ==== Parameters
        # * zone<~String> - Either the zone ID or the zone name (ie sample-domain.com)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'origin'<~String> - domain name to host (ie example.com)
        #     * 'id'<~Integer> - Id of the zone
        #     * 'ttl'<~Integer> - TimeToLive (ttl) for the domain, in seconds (> 60)
        #     * 'active'<~String> - whether zone is active in Slicehost DNS server - 'Y' or 'N'
        def get_zone(zone)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Zerigo::Compute::GetZone.new,
            :path     => "/api/1.1/zones/#{zone}.xml"
          )
        end

      end

      class Mock

        def get_zone(zone)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
