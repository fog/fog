module Fog
  module Rackspace
    class Monitoring
      class Real

        def get_cpus_info(agent_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "agents/#{agent_id}/host_info/cpus"
          )
        end
      end

      class Mock
        def get_cpus_info(agent_id)

          agent_id = Fog::Rackspace::MockData.uuid

          if agent_id == -1
            raise Fog::Rackspace::Monitoring::NotFound
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "values"  => [
              {
                "name"            => "cpu.0",
                "vendor"          => "AMD",
                "model"           => "Opteron",
                "mhz"             => Fog::Mock.random_numbers(4).to_s,
                "idle"            => Fog::Mock.random_numbers(10).to_s,
                "irq"             => Fog::Mock.random_numbers(5).to_s,
                "soft_irq"        => Fog::Mock.random_numbers(7).to_s,
                "nice"            => Fog::Mock.random_numbers(9).to_s,
                "stolen"          => Fog::Mock.random_numbers(7).to_s,
                "sys"             => Fog::Mock.random_numbers(7).to_s,
                "user"            => Fog::Mock.random_numbers(9).to_s,
                "wait"            => Fog::Mock.random_numbers(7).to_s,  
                "total"           => Fog::Mock.random_numbers(11).to_s,
                "total_cores"     => 1,
                "total_sockets"   => 1
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
