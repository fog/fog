module Fog
  module Slicehost
    class Compute
      class Real

        require 'fog/slicehost/parsers/compute/create_record'

        # Create a new record in a DNS zone
        # ==== Parameters
        # * record_type<~String> - type of DNS record to create (A, CNAME, etc)
        # * zone_id<~Integer> - ID of the zone record should be a part of
        # * name<~String> - DNS name record should be for (ie for an A record, the host name)
        # * data<~String> - data for the DNS record (ie for an A record, the IP address)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * 'name'<~String> - domain added 
        #   * 'id'<~Integer> - Id of zone/domain
        #   * 'ttl'<~Integer> - TimeToLive for zone (how long client can cache)
        #   * 'active'<~String> - whether zone is active or disabled
        def create_record( record_type, zone_id, name, data)
          request(
            :body     => %Q{<?xml version="1.0" encoding="UTF-8"?><record><record_type>#{record_type}</record_type><zone_id type="integer">#{zone_id}</zone_id><name>#{name}</name><data>#{data}</data></record>},
            :expects  => 201,
            :method   => 'POST',
            :parser   => Fog::Parsers::Slicehost::Compute::CreateRecord.new,
            :path     => 'records.xml'
          )
        end

      end

      class Mock

        def create_record( record_type, zone_id, name, data)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
