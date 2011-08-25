module Fog
  module DNS
    class Bluebox
      class Real

        # Updates an existing DNS zone
        def update_zone(zone_id, options)
          body = %Q{<?xml version="1.0" encoding="UTF-8"?><domain>}
          options.each {|k,v| body += "<#{k}>#{v}</#{k}>"}
          body += "</domain>"
          request(
            :body     => body,
            :expects  => 202,
            :method   => 'PUT',
            :path     => "/api/domains/#{zone_id}.xml"
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
