module Fog
  module Rackspace
    class Monitoring
      class Real
        def list_entities(options={})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'entities',
            :query    => options
          )
        end
      end

      class Mock
        def list_entities(options={})
          account_id = Fog::Mock.random_numbers(6).to_s
          server_id = Fog::Rackspace::MockData.uuid
          entity_id = Fog::Mock.random_letters(10)
          entity_label = Fog::Mock.random_letters(10)

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "values"=> [
              {
                "id"           => entity_id,
                "label"        => entity_label,
                "ip_addresses" => {
                  "access_ip0_v6" => Fog::Rackspace::MockData.ipv6_address,
                  "public0_v4"    => Fog::Rackspace::MockData.ipv4_address,
                  "public1_v6"    => Fog::Rackspace::MockData.ipv6_address,
                  "access_ip1_v4" => Fog::Rackspace::MockData.ipv4_address,
                  "private0_v4"   => Fog::Rackspace::MockData.ipv4_address
                },
                "metadata"     => nil,
                "managed"      => false,
                "uri"          => "https://ord.servers.api.rackspacecloud.com/" + account_id + "/servers/" + server_id,
                "agent_id"     => nil,
                "created_at"   => Time.now.to_i - 1,
                "updated_at"   => Time.now.to_i
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
