module Fog
  module DNS
    class Bluebox
      class Real

        require 'fog/bluebox/parsers/dns/get_zones'

        # Get list of all DNS zones hosted on Bluebox (for this account)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * 'records'<~Array>
        #     * 'record'
        #       * 'name'<~String> - name of the zone
        #       * 'serial'<~Integer> - Serial # for the zone
        #       * 'ttl'<~Integer> - TTL for the zone record in seconds
        #       * 'retry'<~Integer> - Retry interval for the zone record in seconds
        #       * 'expires'<~Integer> - Expiration interval for the zone record in seconds
        #       * 'record-count'<~Integer> - # of records in this zone
        #       * 'id'<~String> - Id for the zone record
        #       * 'refresh'<~Integer> - default refresh interval for this zone, in seconds
        #       * 'minimum'<~Integer> - minimum value for intervals for this zone, in seconds
        def get_zones
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::DNS::Bluebox::GetZones.new,
            :path     => '/api/domains.xml'
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
