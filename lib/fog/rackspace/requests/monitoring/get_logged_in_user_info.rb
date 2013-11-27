module Fog
  module Rackspace
    class Monitoring
      class Real

        def get_logged_in_user_info(agent_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "agents/#{agent_id}/host_info/who"
          )
        end
      end

      class Mock
        def get_logged_in_user_info(agent_id)

          agent_id = Fog::Rackspace::MockData.uuid

          if agent_id == -1
            raise Fog::Rackspace::Monitoring::NotFound
          end
          
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "values"  => [
              {
                "user"      => "root",
                "device"    => "pts/1",
                "time"      => Time.now.to_i - 100,
                "host"      => "somehost1.company.local"
              },
              {
                "user"      => "user123",
                "device"    => "pts/2",
                "time"      => Time.now.to_i - 50,
                "host"      => "somehost2.company.local"
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
