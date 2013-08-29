module Fog
  module Rackspace
    class Monitoring
      class Real

        def update_check(entity_id, id, options)
          request(
            :body     => JSON.encode(options),
            :expects  => [204],
            :method   => 'PUT',
            :path     => "entities/#{entity_id}/checks/#{id}"
          )
        end
      end

      class Mock
        def update_check(entity_id, id, options)

          if options[:testing] == "Bar"
            raise Fog::Rackspace::Monitoring::NotFound
          end

          response = Excon::Response.new
          response.status = 204
          response.body = ""
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Location"              => "https://monitoring.api.rackspacecloud.com/v1.0/55555/entities/" + entity_id + "/checks/mock_id",
            "X-Object-ID"           => "mock_id",
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "49627",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => ".rh-lHJL.h-ord1-maas-prod-api1.r-AGRIH406.c-4085336.ts-1377785008661.v-e602877",
            "X-LB"                  => "ord1-maas-prod-api1",
            "Content-Length"        => "0",
            "Content-Type"          => "text/plain",
          }
          response.remote_ip = "1.1.1.1"
          response
        end
      end
    end
  end
end

