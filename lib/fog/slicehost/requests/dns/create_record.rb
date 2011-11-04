module Fog
  module DNS
    class Slicehost
      class Real

        require 'fog/slicehost/parsers/dns/create_record'

        # Create a new record in a DNS zone - or update an existing one
        # ==== Parameters
        # * record_type<~String> - type of DNS record to create (A, CNAME, etc)
        # * zone_id<~Integer> - ID of the zone to update
        # * name<~String> - host name this DNS record is for
        # * data<~String> - data for the DNS record (ie for an A record, the IP address)
        # * options<~Hash> - extra parameters that are not mandatory
        #   * ttl<~Integer> - time to live in seconds
        #   * active<~String> - whether this record is active or not ('Y' or 'N')
        #   * aux<~String> - extra data required by the record
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'name'<~String> - as above
        #     * 'id'<~Integer> - Id of zone/domain - used in future API calls for this zone
        #     * 'ttl'<~Integer> - as above
        #     * 'data'<~String> - as above
        #     * 'active'<~String> - as above
        #     * 'aux'<~String> - as above
        def create_record(record_type, zone_id, name, data, options = {})
          optional_tags= ''
          options.each { |option, value|
            case option
            when :ttl
              optional_tags+= "<ttl type='integer'>#{value}</ttl>"
            when :active
              optional_tags+= "<active>#{value}</active>"
            when :aux
              optional_tags+= "<aux>#{value}</aux>"
            end
          }

          request(
            :body     => %Q{<?xml version="1.0" encoding="UTF-8"?><record><record_type>#{record_type}</record_type><zone_id type="integer">#{zone_id}</zone_id><name>#{name}</name><data>#{data}</data>#{optional_tags}</record>},
            :expects  => 201,
            :method   => 'POST',
            :parser   => Fog::Parsers::DNS::Slicehost::CreateRecord.new,
            :path     => 'records.xml'
          )
        end

      end
    end
  end
end
