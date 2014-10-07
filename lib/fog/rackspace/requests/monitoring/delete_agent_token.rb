module Fog
  module Rackspace
    class Monitoring
      class Real
        def delete_agent_token(token_id)
          request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "agent_tokens/#{token_id}"
          )
        end
      end

      class Mock
        def delete_agent_token(options = {})
          account_id = Fog::Mock.random_numbers(6).to_s
          token = Fog::Mock.random_letters(50).to_s

          if options == -1
            raise Fog::Rackspace::Monitoring::NotFound
          end

          response = Excon::Response.new
          response.status = 201
          response.body = ""
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Location"              => "https://monitoring.api.rackspacecloud.com/v1.0/" + account_id + "/agent_tokens/" + token,
            "X-Object-ID"           => token,
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "49627",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "lsknvnslnv2083ovnsdbno00",
            "X-LB"                  => "ord1-maas-prod-api1",
            "Content-Length"        => "0",
            "Content-Type"          => "text/plain",
          }
          response.remote_ip = Fog::Rackspace::MockData.ipv4_address
          response
        end
      end
    end
  end
end
