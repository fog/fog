module Fog
  module Rackspace
    class Monitoring
      class Real

        def list_entities(options={})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'entities',
            :query    => options
          )
        end
      end
      
      class Mock
        def list_entities(options={})
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "values"=> [
              {
                "id"           => "foo_id",
                "label"        => "foo_label",
                "ip_addresses" => {
                  "access_ip0_v6" => "::1",
                  "public0_v4"    => "1.1.1.1",
                  "public1_v6"    => "::1",
                  "access_ip1_v4" => "1.1.1.1",
                  "private0_v4"   => "10.10.10.1"
                },
                "metadata"     => nil,
                "managed"      => false,
                "uri"          => "https://ord.servers.api.rackspacecloud.com/55555/servers/B0791A1C-E798-4D55-A24C-28EE0305245C",
                "agent_id"     => nil,
                "created_at"   => Time.now.to_i - 1,
                "updated_at"   => Time.now.to_i
              }
          ],
            "metadata" => {
               "count"       => 1,
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
            "X-Response-Id"         =>" j23jlk234jl2j34j",
            "X-LB"                  => "dfw1-maas-prod-api0",
            "Vary"                  => "Accept-Encoding",
            "Transfer-Encoding"     => "chunked"
          }
          response
        end
      end
    end
  end
end

