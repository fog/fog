module Fog
  module DNS
    class Zerigo
      class Real

        require 'fog/zerigo/parsers/dns/get_zone_stats'

        # returns current traffic statistics about this zone. Queries is measured from the 
        # beginning of the current period through the time of the API call.
        #
        # ==== Parameters
        # * zone_id<~Integer> - the zone ID 
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'domain'<~String> - domain name  (ie example.com)
        #     * 'id'<~Integer> - Id of the zone
        #     * 'period-being'<~String> - date in following format 2010-07-01
        #     * 'period-end'<~String> - date
        #     * 'queries'<~Integer> - # of queries for the zone during period
        #   * 'status'<~Integer> - 200 indicates success
        
        def get_zone_stats(zone_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::DNS::Zerigo::GetZoneStats.new,
            :path     => "/api/1.1/zones/#{zone_id}/stats.xml"
          )
        end

      end
    end
  end
end
