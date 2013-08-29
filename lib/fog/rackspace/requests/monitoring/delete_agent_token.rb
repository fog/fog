module Fog
  module Rackspace
    class Monitoring
      class Real

        def delete_agent_token(token_id)
          request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "agent_tokens/#{token_id}"
          )
        end
      end

      class Mock
        def delete_agent_token(options = {})
          response = Excon::Response.new
          response.status = 201
          response.body = ""
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Location"              => "https://monitoring.api.rackspacecloud.com/v1.0/55555/agent_tokens/7e261310b36834a9969e389c8e90adc08629c00d4c74aaea5e42599cc07ba80d.55555",
            "X-Object-ID"           => "7e261310b36834a9969e389c8e90adc08629c00d4c74aaea5e42599cc07ba80d.55555",
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

