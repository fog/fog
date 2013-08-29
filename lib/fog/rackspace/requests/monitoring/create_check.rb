module Fog
  module Rackspace
    class Monitoring
      class Real

        def create_check(entity_id, options = {})
          data = options.dup
          request(
            :body     => JSON.encode(data),
            :expects  => [201],
            :method   => 'POST',
            :path     => "entities/#{entity_id}/checks"
          )
        end
      end

      class Mock
        def create_check(entity_id, options = {})
          
          if options[:type] == ""
            raise Fog::Rackspace::Monitoring::BadRequest
          end

          response = Excon::Response.new
          response.status = 201
          response.body = ""
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Location"              => "https://monitoring.api.rackspacecloud.com/v1.0/55555/" + entity_id + "/checks/mock_id",
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

