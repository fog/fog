module Fog
  module DNS
    class Bluebox
      class Real
        require 'fog/bluebox/parsers/dns/create_zone'

        # Create a new DNS zone
        # ==== Parameters
        #     * 'name'<~String> - The name of the zone
        #     * 'ttl'<~Integer> - TimeToLive (ttl) for the domain, in seconds
        #     * 'retry'<~Integer> - Retry interval for the domain, in seconds
        #     * 'refresh'<~Integer> - Refresh interval for the zone
        #     * 'minimum'<~Integer> - Minimum refresh interval for the zone
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'name'<~String> - The name of the zone
        #     * 'serial'<~Integer> - Serial number of the zone
        #     * 'ttl'<~Integer> - TimeToLive (ttl) for the domain, in seconds
        #     * 'retry'<~Integer> - Retry interval for the domain, in seconds
        #     * 'record-count'<~Integer> - Number of records in the zone
        #     * 'id'<~String> - Id for the zone
        #     * 'refresh'<~Integer> - Refresh interval for the zone
        #     * 'minimum'<~Integer> - Minimum refresh interval for the zone
        def create_zone(options)
          body = %Q{<?xml version="1.0" encoding="UTF-8"?><domain><name>#{options[:name]}</name><ttl>#{options[:ttl]}</ttl>}
          body += %Q{<retry>#{options[:retry]}</retry>} if options[:retry]
          body += %Q{<refresh>#{options[:retry]}</refresh>} if options[:refresh]
          body += %Q{<minimum>#{options[:minimum]}</minimum>} if options[:minimum]
          body += %Q{</domain>}
          request(
            :body     => body,
            :expects  => 202,
            :method   => 'POST',
            :parser   => Fog::Parsers::DNS::Bluebox::CreateZone.new,
            :path     => "/api/domains.xml"
          )
        end
      end

      class Mock
        def create_zone(options)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
