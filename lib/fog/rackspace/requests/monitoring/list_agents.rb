module Fog
  module Rackspace
    class Monitoring
      class Real
        def list_agents
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "agents"
          )
        end
      end

      class Mock
        def list_agents
          response = Excon::Response.new
          response.status = 200
          response.body = {
          "values"=>[
          {
          	"id"		=> Fog::Rackspace::MockData.uuid,
          	"last_connected"  => Time.now.to_i - 100
          },
          {
          	"id"		=> Fog::Rackspace::MockData.uuid,
          	"last_connected"  => Time.now.to_i - 110
          },
          {
          	"id"		=> Fog::Rackspace::MockData.uuid,
          	"last_connected"  => Time.now.to_i - 120
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
            "X-Response-Id"         => "j23jlk234jl2j34j",
            "X-LB"                  => "dfw1-maas-prod-api0",
            "Vary"                  => "Accept-Encoding",
            "Transfer-Encoding"     => "chunked"
          }
          response.remote_ip = Fog::Mock.random_ip({:version => :v4})
          response
        end
      end
    end
  end
end
