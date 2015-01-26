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
          if agent_id == -1
            raise Fog::Rackspace::Monitoring::BadRequest
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "info"  => [
              {
                "name"            => "cpu.0",
                "vendor"          => "AMD",
                "model"           => "Opteron",
                "mhz"             => Fog::Mock.random_numbers(4).to_i,
                "idle"            => Fog::Mock.random_numbers(10).to_i,
                "irq"             => Fog::Mock.random_numbers(5).to_i,
                "soft_irq"        => Fog::Mock.random_numbers(7).to_i,
                "nice"            => Fog::Mock.random_numbers(9).to_i,
                "stolen"          => Fog::Mock.random_numbers(7).to_i,
                "sys"             => Fog::Mock.random_numbers(7).to_i,
                "user"            => Fog::Mock.random_numbers(9).to_i,
                "wait"            => Fog::Mock.random_numbers(7).to_i,
                "total"           => Fog::Mock.random_numbers(11).to_i,
                "total_cores"     => 1,
                "total_sockets"   => 1
              }
            ]
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
