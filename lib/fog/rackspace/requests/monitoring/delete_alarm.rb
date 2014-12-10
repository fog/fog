module Fog
  module Rackspace
    class Monitoring
      class Real
        def delete_alarm(entity_id, alarm_id)
          request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "entities/#{entity_id}/alarms/#{alarm_id}"
          )
        end
      end

      class Mock
        def delete_alarm(entity_id, alarm_id)
          if entity_id == -1 || alarm_id == -1
            raise Fog::Rackspace::Monitoring::NotFound
          end

          response = Excon::Response.new
          response.status = 204
          response.body = ""
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Content-Type"          => "application/json; charset=UTF-8",
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "38687",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "pomsbnio93gm3030fm303.mmowd",
            "X-LB"                  => "ord1-maas-prod-api0",
            "Vary"                  => "Accept-Encoding",
            "Content-Length"        => "0"
          }
          response.remote_ip = Fog::Rackspace::MockData.ipv4_address
          response
        end
      end
    end
  end
end
