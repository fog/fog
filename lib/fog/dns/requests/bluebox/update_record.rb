module Fog
  module Bluebox
    class DNS
      class Real

        # Updates an existing record in a DNS zone
        # ==== Parameters
        # * type<~String> - type of DNS record (A, CNAME, etc)
        # * name<~String> - host name for this DNS record
        # * content<~String> - data for the DNS record (ie for an A record, the IP address)
        def update_record(zone_id, record_id, options)
          body = %Q{<?xml version="1.0" encoding="UTF-8"?><record>}
          options.each {|k,v| body += "<#{k}>#{v}</#{k}>"}
          body += "</record>"
          request(
            :body     => body,
            :expects  => 202,
            :method   => 'PUT',
            :path     => "/api/domains/#{zone_id}/records/#{record_id}.xml"
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
