module Fog
  module Rackspace
    class Monitoring
      class Real

        def create_alarm(entity_id, options = {})
          data = options.dup
          request(
            :body     => JSON.encode(data),
            :expects  => [201],
            :method   => 'POST',
            :path     => "entities/#{entity_id}/alarms"
          )
        end
      end

      class Mock
        def create_alarm(entity_id, options = {})

          if options[:type]
            raise Fog::Rackspace::Monitoring::BadRequest
          end

          response = Excon::Response.new
          response.status = 201
          response.body = ""
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Location"              => "https://monitoring.api.rackspacecloud.com/v1.0/817815/entities/" + entity_id.to_s + "/alarms/fooalarmid",
            "X-Object-ID"           => "fooalarmid",
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "47877",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "laolsgggopnnsv",
            "X-LB"                  => "dfw1-maas-prod-api1",
            "Content-Length"        => "0",
            "Content-Type"          => "text/plain"
          }
          response.remote_ip = "1.1.1.1"
          response
        end
      end
    end
  end
end

