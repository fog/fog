module Fog
  module DNS
    class Bluebox
      class Real
        require 'fog/bluebox/parsers/dns/get_zone'

        # Get details of a DNS zone
        #
        # ==== Parameters
        # * zone_id<~Integer> - Id of zone to lookup
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * hash<~Hash>:
        #     * 'name'<~String> - The name of the zone
        #     * 'serial'<~Integer> - Serial number of the zone
        #     * 'ttl'<~Integer> - TimeToLive (ttl) for the domain, in seconds
        #     * 'retry'<~Integer> - Retry interval for the domain, in seconds
        #     * 'record-count'<~Integer> - Number of records in the zone
        #     * 'id'<~String> - Id for the zone
        #     * 'refresh'<~Integer> - Refresh interval for the zone
        #     * 'minimum'<~Integer> - Minimum refresh interval for the zone
        def get_zone(zone_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::DNS::Bluebox::GetZone.new,
            :path     => "/api/domains/#{zone_id}.xml"
          )
        end
      end

      class Mock
        def get_zone(zone_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
