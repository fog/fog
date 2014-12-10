module Fog
  module Rackspace
    class Monitoring
      class Real
        def list_notification_plans
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "notification_plans"
          )
        end
      end

      class Mock
        def list_notification_plans
          notification_id   = Fog::Mock.random_letters(10)

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "values" => [
              {
                "id"    => "npTechnicalContactsEmail",
                "label" => "Technical Contacts - Email",
                "critical_state" => [],
                "warning_state"  => [],
                "ok_state" => []
              },

              {
                "id"             => "notification_id",
                "label"          => "mock_label",
                "critical_state" => nil,
                "warning_state"  => nil,
                "ok_state"       => nil,
                "created_at"     => Time.now.to_i - 2,
                "updated_at"     => Time.now.to_i - 1
              }
            ],

            "metadata" => {
              "count"       => 2,
              "limit"       => 100,
              "marker"      => nil,
              "next_marker" => nil,
              "next_href"   => nil
            }

          }

          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Content-Type"          => "application/json; charset=UTF-8",
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "49627",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         =>" zsdvasdtrq345",
            "X-LB"                  => "dfw1-maas-prod-api0",
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
