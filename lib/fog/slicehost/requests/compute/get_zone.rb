module Fog
  module Slicehost
    class Compute
      class Real

        require 'fog/slicehost/parsers/compute/get_zone'

        # Get details of a DNS zone
        #
        # ==== Parameters
        # * zone_id<~Integer> - Id of zone to lookup
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'origin'<~String> - Name of zone details are being requested of
        #     * 'id'<~Integer> - Id of the zone
        #     * 'ttl'<~Integer> - TimeToLive (ttl) for the zone
        #     * 'active'<~String> - 'Y' or 'N' - if the zone is active or disabled
        def get_zone(zone_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Slicehost::Compute::GetZone.new,
            :path     => "/zones/#{zone_id}.xml"
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
