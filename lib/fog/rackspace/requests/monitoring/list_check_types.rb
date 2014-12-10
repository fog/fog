module Fog
  module Rackspace
    class Monitoring
      class Real
        def list_check_types
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "check_types"
          )
        end
      end

      class Mock
        def list_check_types
          response = Excon::Response.new
          response.status = 200
          response.body = {

            "values" => [
              {
                "type"   => "remote",
                "id"     => "remote.dns",
                "channel"=> "stable",
                "fields" => [
                  {
                    "name"       => "port",
                    "description"=> "Port number (default: 53)",
                    "optional"   => true
                  },
                  {
                    "name"       => "query",
                    "description"=> "DNS Query",
                    "optional"   => false
                  },
                  {
                    "name"        => "record_type",
                    "description" => "DNS Record Type",
                    "optional"    => false
                  }
                ],
                "category" => "remote"
              },

              {
                "type"    => "agent",
                "id"      => "agent.memory",
                "channel" =>"stable",
                "fields"  => [],
                "supported_platforms" => [
                  "Linux",
                  "Windows"
                ],
                "category" => "agent_system"
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
