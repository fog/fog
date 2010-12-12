module Fog
  module Zerigo
    class Compute
      class Real

        require 'fog/zerigo/parsers/compute/get_zone_stats'

        # returns current traffic statistics about this zone. Queries is measured from the 
        # beginning of the current period through the time of the API call.
        #
        # ==== Parameters
        # * zone<~Integer> - the zone ID 
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'domain'<~String> - domain name  (ie example.com)
        #     * 'id'<~Integer> - Id of the zone
        #     * 'period-being'<~String> - date in following format 2010-07-01
        #     * 'period-end'<~String> - date
        #     * 'queries'<~Integer> - # of queries for the zone during period
        def get_zone_stats(zone_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Zerigo::Compute::GetZoneStats.new,
            :path     => "/api/1.1/zones/#{zone}/stats.xml"
          )
        end

      end

      class Mock

        def get_zone_stats(zone_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
