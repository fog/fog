module Fog
  module DNS
    class Bluebox
      class Real
        require 'fog/bluebox/parsers/dns/get_record'

        # Get an individual DNS record from the specified zone
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * hash<~Hash>:
        #     * 'id'<~String> - The id of this record
        #     * 'type'<~String> - type of DNS record to create (A, CNAME, etc)
        #     * 'domain-id'<~Integer> - ID of the zone
        #     * 'name'<~String> - empty?
        #     * 'domain'<~String> - The domain name
        #     * 'type'<~String> - The type of DNS record (e.g. A, MX, NS, etc.)
        #     * 'content'<~String> - data for the DNS record (ie for an A record, the IP address)
        def get_record(zone_id, record_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::DNS::Bluebox::GetRecord.new,
            :path     => "/api/domains/#{zone_id}/records/#{record_id}.xml"
          )
        end
      end

      class Mock
        def get_record(record_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
