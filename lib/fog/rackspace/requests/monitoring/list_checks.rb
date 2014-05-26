module Fog
  module Rackspace
    class Monitoring
      class Real
        def list_checks(entity_id, options={})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "entities/#{entity_id}/checks",
            :query    => options
          )
        end
      end

      class Mock
        def list_checks(entity_id)
          check_id = Fog::Mock.random_letters(10)

          if entity_id == -1
            raise Fog::Rackspace::Monitoring::NotFound
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "values"  => [
              {
                "id"              => check_id,
                "label"           => "load",
                "type"            => "agent.load_average",
                "details"         => {},
                "monitoring_zones_poll" => nil,
                "timeout"         => 10,
                "period"          => 30,
                "target_alias"    => nil,
                "target_hostname" => nil,
                "target_resolver" => nil,
                "disabled"        => false,
                "metadata"        => nil,
                "created_at"      => Time.now.to_i - 1,
                "updated_at"      => Time.now.to_i
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
          response.remote_ip = Fog::Rackspace::MockData.ipv4_address
          response
        end
      end
    end
  end
end
