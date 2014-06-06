module Fog
  module Rackspace
    class Monitoring
      class Real
        def list_metrics(entity_id, check_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "entities/#{entity_id}/checks/#{check_id}/metrics"
          )
        end
      end

    class Mock
      def list_metrics(entity_id, check_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "values" => [
              {
                "name" => "idle_percent_average",
                "unit" => "percent"
              },
              { "name" => "irq_percent_average",
                "unit" => "percent"
              },
              { "name" => "max_cpu_usage",
                "unit" => "percent"
              },
              { "name" => "min_cpu_usage",
                "unit" => "percent"
              },
              { "name" => "stolen_percent_average",
                "unit" => "percent"
              },
              { "name" => "sys_percent_average",
                "unit" => "percent"
              },
              {
                "name" => "usage_average",
                "unit" => "percent"
              },
              { "name" => "user_percent_average",
                "unit" => "percent"
              },
              { "name" => "wait_percent_average",
                "unit" => "percent"
              }
            ],

            "metadata" => {
              "count"       => 9,
              "limit"       => nil,
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
          "X-Response-Id"         => "zsdvasdtrq345",
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
