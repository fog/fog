module Fog
  module Rackspace
    class Monitoring
      class Real
        def get_memory_info(agent_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "agents/#{agent_id}/host_info/memory"
          )
        end
      end

      class Mock
        def get_memory_info(agent_id)
          if agent_id == -1
            raise Fog::Rackspace::Monitoring::BadRequest
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "info"  => [
              {
                "actual_free"     => Fog::Mock.random_numbers(9).to_i,
                "actual_used"     => Fog::Mock.random_numbers(8).to_i,
                "free"            => Fog::Mock.random_numbers(7).to_i,
                "used"            => Fog::Mock.random_numbers(9).to_i,
                "total"           => Fog::Mock.random_numbers(10).to_i,
                "ram"           => Fog::Mock.random_numbers(4).to_i,
                "swap_total"      => Fog::Mock.random_numbers(10).to_i,
                "swap_used"       => Fog::Mock.random_numbers(8).to_i,
                "swap_free"       => Fog::Mock.random_numbers(10).to_i,
                "swap_page_in"    => Fog::Mock.random_numbers(3).to_i,
                "swap_page_out"   => Fog::Mock.random_numbers(3).to_i,
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
