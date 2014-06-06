module Fog
  module Rackspace
    class Monitoring
      class Real
        def get_alarm(entity_id, alarm_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "entities/#{entity_id}/alarms/#{alarm_id}"
          )
        end
      end

      class Mock
        def get_alarm(entity_id, alarm_id)
          if entity_id == -1 || alarm_id == -1
           raise Fog::Rackspace::Monitoring::NotFound
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "id"                    => alarm_id,
            "label"                 => nil,
            "check_id"              => Fog::Mock.random_letters(10),
            "criteria"              => nil,
            "disabled"              => false,
            "notification_plan_id"  => "npTechnicalContactsEmail",
            "metadata"              => nil,
            "created_at"            => Time.now.to_i - 1,
            "updated_at"            => Time.now.to_i
          }
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Content-Type"          => "application/json; charset=UTF-8",
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "38687",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "pomkondbno93gm3030fm303.mmowd",
            "X-LB"                  => "ord1-maas-prod-api0",
            "Vary"                  => "Accept-Encoding",
            "Transfer-Encoding"     => "chunked"
          }
          response.remote_ip = Fog::Rackspace::MockData.ipv4_address
          response
        end
      end
    end
  end
end
