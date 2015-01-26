module Fog
  module Rackspace
    class Monitoring
      class Real
        def get_agent_token(id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "agent_tokens/#{id}"
          )
        end
      end

      class Mock
        def get_agent_token(id)
          token = Fog::Mock.random_letters(50).to_s

          if id == -1
            raise TypeError
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "id"      => token,
            "token"   => token,
            "label"   => "mock_token"
          }
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Content-Type"          => "application/json; charset=UTF-8",
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "47903",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "kvnsdonvosnv92989vbvbob",
            "X-LB"                  => "ord1-maas-prod-api0",
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
