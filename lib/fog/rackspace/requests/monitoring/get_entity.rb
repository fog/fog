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
          account_id = Fog::Mock.random_numbers(6).to_s
          server_id = Fog::Rackspace::MockData.uuid
          entity_label = Fog::Mock.random_letters(10)

          if entity_id == -1
            raise Fog::Rackspace::Monitoring::NotFound
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "id"            => entity_id,
            "label"         => entity_label,
             "metadata"     => nil,
             "managed"      => false,
             "uri"          => "https://ord.servers.api.rackspacecloud.com/" + account_id + "/servers/" + server_id,
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
          response.remote_ip = Fog::Rackspace::MockData.ipv4_address
          response
        end
      end
    end
  end
end
