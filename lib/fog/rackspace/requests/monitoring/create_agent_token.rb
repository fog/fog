module Fog
  module Rackspace
    class Monitoring
      class Real

        def create_agent_token(options = {})
          data = options.dup
          request(
            :body     => JSON.encode(data),
            :expects  => [201],
            :method   => 'POST',
            :path     => 'agent_tokens'
          )
        end
      end

      class Mock
        def create_agent_token(options = {})
          
          if options == -1
            raise TypeError
          end

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

