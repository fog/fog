module Fog
  module DNS
    class Slicehost
      class Real

        require 'fog/slicehost/parsers/dns/get_record'

        # Get an individual DNS record from the specified zone
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'record_type'<~String> - type of DNS record to create (A, CNAME, etc)
        #     * 'zone_id'<~Integer> - ID of the zone to update
        #     * 'name'<~String> - host name this DNS record is for
        #     * 'data'<~String> - data for the DNS record (ie for an A record, the IP address)
        #     * 'ttl'<~Integer> - time to live in seconds
        #     * 'active'<~String> - whether this record is active or not ('Y' or 'N')
        #     * 'aux'<~String> - extra data required by the record
        def get_record(record_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::DNS::Slicehost::GetRecord.new,
            :path     => "records/#{record_id}.xml"
          )
        end

      end
    end
  end
end
