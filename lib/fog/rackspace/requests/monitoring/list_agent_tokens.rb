module Fog
  module Rackspace
    class Monitoring
      class Real
        def list_agent_tokens(options={})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'agent_tokens',
            :query    => options
          )
        end
      end

      class Mock
        def list_agent_tokens(options={})
          token = Fog::Mock.random_letters(50).to_s

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "values"=> [
              {
                "id"      => token,
                "token"   => token,
                "label"   => "mock_token"
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
          response.remote_ip = Fog::Rackspace::MockData.ipv4_address
          response
        end
      end
    end
  end
end
