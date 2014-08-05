module Fog
  module Rackspace
    class Monitoring
      class Real
        def create_check(entity_id, options = {})
          data = options.dup
          request(
            :body     => JSON.encode(data),
            :expects  => [201],
            :method   => 'POST',
            :path     => "entities/#{entity_id}/checks"
          )
        end
      end

      class Mock
        def create_check(entity_id, options = {})
          account_id = Fog::Mock.random_numbers(6).to_s
          mock_id = Fog::Mock.random_letters(10).to_s

          if options[:type] == ""
            raise Fog::Rackspace::Monitoring::BadRequest
          end

          response = Excon::Response.new
          response.status = 201
          response.body = ""
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Location"              => "https://monitoring.api.rackspacecloud.com/v1.0/" + account_id + "/" + entity_id + "/checks/" + mock_id,
            "X-Object-ID"           => mock_id,
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "49627",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "knvlknvosnd20038hgouwvn9nv",
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
