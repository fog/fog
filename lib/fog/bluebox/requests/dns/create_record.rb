module Fog
  module DNS
    class Bluebox
      class Real

        require 'fog/bluebox/parsers/dns/create_record'

        # Create a new record in a DNS zone
        # ==== Parameters
        # * type<~String> - type of DNS record to create (A, CNAME, etc)
        # * name<~String> - host name this DNS record is for
        # * content<~String> - data for the DNS record (ie for an A record, the IP address)
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'name'<~String> - as above
        #     * 'id'<~Integer> - Id of zone/domain - used in future API calls for this zone
        #     * 'ttl'<~Integer> - as above
        #     * 'data'<~String> - as above
        #     * 'active'<~String> - as above
        #     * 'aux'<~String> - as above
        def create_record(zone_id, type, name, content, options={})
          body = %Q{<?xml version="1.0" encoding="UTF-8"?><record><type>#{type}</type><name>#{name}</name><content>#{content}</content>}
          options.each do |k,v|
            body += %Q{<#{k}>#{v}</#{k}>}
          end
          body += %Q{</record>}
          request(
            :body     => body,
            :expects  => 202,
            :method   => 'POST',
            :parser   => Fog::Parsers::DNS::Bluebox::CreateRecord.new,
            :path     => "/api/domains/#{zone_id}/records.xml"
          )
        end

      end

      class Mock

        def create_record(zone_id, type, name, content)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
