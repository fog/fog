module Fog
  module Bluebox
    class DNS
      class Real

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
        def create_record(zone_id, type, domain, content)
          request(
            :body     => %Q{<?xml version="1.0" encoding="UTF-8"?><record><type>#{type}</type><name>#{domain}</name><content>#{content}</content></record>},
            :expects  => 202,
            :method   => 'POST',
            :path     => "/api/domains/#{zone_id}/records.xml"
          )
        end

      end

      class Mock

        def create_record(zone_id, type, domain, content)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
