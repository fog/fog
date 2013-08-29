module Fog
  module Rackspace
    class Monitoring
      class Real

        def get_entity(entity_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "entities/#{entity_id}"
          )
        end

      end

      class Mock

        def get_entity(entity_id)

          if entity_id == -1
            raise Fog::Rackspace::Monitoring::NotFound
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "id"            => entity_id.to_s,
            "label"         => "foolabel",
            "ip_addresses"  => {
                "access_ip0_v6"  => "::1",
                "public0_v4"     => "1.1.1.1",
                "public1_v6"     => "::1",
                "access_ip1_v4"  => "1.1.1.1",
                "private0_v4"    => "10.10.10.1"
              },
             "metadata"     => nil,
             "managed"      => false,
             "uri"          => "https://ord.servers.api.rackspacecloud.com/55555/servers/27F99694-1775-4631-AFEA-0E1BA824ED86",
             "agent_id"     => nil,
             "created_at"   => Time.now.to_i - 1,
             "updated_at"   => Time.now.to_i

          }
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Content-Type"          => "application/json; charset=UTF-8",
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "49627",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "j23jlkgmngjl2j34j",
            "X-LB"                  => "dfw1-maas-prod-api0",
            "Vary"                  => "Accept-Encoding",
            "Transfer-Encoding"     => "chunked"
          }
        end
      end
    end
  end
end


