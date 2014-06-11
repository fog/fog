module Fog
  module Rackspace
    class Monitoring
      class Real
        def delete_entity(entity_id)
          request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "entities/#{entity_id}"
          )
        end
      end

      class Mock
        def delete_entity(entity_id)
          if entity_id == -1
           raise Fog::Rackspace::Monitoring::NotFound
          end

          response = Excon::Response.new
          response.status = 204
          response.body = ""
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "47877",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "lakgnnnf9bgewkgb39sobnsv",
            "X-LB"                  => "ord1-maas-prod-api1",
            "Content-Length"        => "0",
            "Content-Type"          => "text/plain"
          }
          response.remote_ip = Fog::Rackspace::MockData.ipv4_address
          response
        end
      end
    end
  end
end
