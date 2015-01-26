module Fog
  module Rackspace
    class Monitoring
      class Real
        def get_notification(notification_id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "notifications/#{notification_id}"
          )
        end
      end

      class Mock
        def get_notification(notification_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
              "created_at" => 1378783452067,
              "details" => {
                  "address" => "test@test.com"
              },
              "id" => "ntnJN3MQrA",
              "label" => "my email update test",
              "type" => "email",
              "updated_at" => 1378784136307
          }

          response.headers = {
            "Date"=> Time.now.utc.to_s,
            "Content-Type"=>"application/json; charset=UTF-8",
            "X-RateLimit-Limit"=>"50000",
            "X-RateLimit-Remaining"=>"49627",
            "X-RateLimit-Window"=>"24 hours",
            "X-RateLimit-Type"=>"global",
            "X-Response-Id"=>"j23jlk234jl2j34j",
            "X-LB"=>"dfw1-maas-prod-api0",
            "Vary"=>"Accept-Encoding",
            "Transfer-Encoding"=>"chunked"
          }
          response
        end
      end
    end
  end
end
