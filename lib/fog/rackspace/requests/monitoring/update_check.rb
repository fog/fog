module Fog
  module Rackspace
    class Monitoring
      class Real
        def update_check(entity_id, check_id, options)
          request(
            :body     => JSON.encode(options),
            :expects  => [204],
            :method   => 'PUT',
            :path     => "entities/#{entity_id}/checks/#{check_id}"
          )
        end
      end

      class Mock
        def update_check(entity_id, check_id, options)
           account_id = Fog::Mock.random_numbers(6).to_s

          if entity_id == -1 || check_id == -1 || options[:testing]
            raise Fog::Rackspace::Monitoring::NotFound
          end

          response = Excon::Response.new
          response.status = 204
          response.body = ""
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Location"              => "https://monitoring.api.rackspacecloud.com/v1.0/" + account_id + "/entities/" + entity_id + "/checks/" + check_id,
            "X-Object-ID"           => check_id,
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "49627",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "owbgowb989wno73ubgvw89",
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
