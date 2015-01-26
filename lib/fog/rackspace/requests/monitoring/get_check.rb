module Fog
  module Rackspace
    class Monitoring
      class Real
        def get_check(entity_id, check_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "entities/#{entity_id}/checks/#{check_id}"
          )
        end
      end

      class Mock
        def get_check(entity_id, check_id)
          if entity_id == -1 || check_id == -1
            raise Fog::Rackspace::Monitoring::NotFound
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "id"                    => check_id,
            "label"                 => nil,
            "type"                  => "remote.ping",
            "details"               => {"count"=>5},
            "monitoring_zones_poll" => ["mzord", "mzdfw", "mziad"],
            "timeout"               => 10,
            "period"                => 30,
            "target_alias"          => nil,
            "target_hostname"       => "1.1.1.1",
            "target_resolver"       => "IPv4",
            "disabled"              => false,
            "metadata"              => nil,
            "created_at"            => Time.now.to_i - 1,
            "updated_at"            => Time.now.to_i
          },
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Content-Type"          => "application/json; charset=UTF-8",
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "44676",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "jdnbono34090934nggn",
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
