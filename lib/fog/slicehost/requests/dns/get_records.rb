module Fog
  module DNS
    class Slicehost
      class Real

        require 'fog/slicehost/parsers/dns/get_records'

        # Get all the DNS records across all the DNS zones for this account
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'name'<~String> - Record NAME field (e.g. "example.org." or "www")
        #     * 'data'<~String> - Data contained by the record (e.g. an IP address, for A records)
        #     * 'record_type'<~String> - Type of record (A, CNAME, TXT, etc)
        #     * 'aux'<~String> - Aux data for the record, for those types which have it (e.g. TXT)
        #     * 'zone_id'<~Integer> - zone ID to which this record belongs
        #     * 'active'<~String> - whether this record is active in the Slicehost DNS (Y for yes, N for no)
        #     * 'ttl'<~Integer> - TTL in seconds
        def get_records
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::DNS::Slicehost::GetRecords.new,
            :path     => "records.xml"
          )
        end

      end
    end
  end
end
