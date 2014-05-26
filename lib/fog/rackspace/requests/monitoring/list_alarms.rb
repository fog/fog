module Fog
  module Rackspace
    class Monitoring
      class Real
        def list_alarms(entity_id, options={})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "entities/#{entity_id}/alarms",
            :query    => options
          )
        end
      end

      class Mock
        def list_alarms(entity_id)
          if entity_id == -1
           raise Fog::Rackspace::Monitoring::NotFound
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "values" => [
             {
              "id"                    => Fog::Mock.random_letters(10),
              "label"                 => nil,
              "check_id"              => Fog::Mock.random_letters(10),
              "criteria"              => nil,
              "disabled"              => false,
              "notification_plan_id"  => "npTechnicalContactsEmail",
              "metadata"              => nil,
              "created_at"            => Time.now.to_i - 1,
              "updated_at"            => Time.now.to_i
             }
            ],
              "metadata" =>
              {
                "count"       =>1,
                "limit"       =>100,
                "marker"      =>nil,
                "next_marker" =>nil,
                "next_href"   =>nil
              }
          }
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Content-Type"          => "application/json; charset=UTF-8",
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "38687",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "pomegmgm3030fm303.mmowd",
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
