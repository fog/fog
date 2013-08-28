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
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "id" => entity_id,
            "label"=>"mocked_fog_entitiy",
            "ip_addresses"=>{
              "private0_v4"=>"10.0.0.1"
            },
            "metadata"=>nil,
            "managed"=>false,
            "uri"=>"https://ord.servers.api.rackspacecloud.com/5555/servers/23kj2q4hk234",
            "agent_id"=>nil,
            "created_at"=> Time.now.to_i - 5000,
            "updated_at"=> Time.now.to_i
          }
          response.headers = {
            "Date"=> Time.now.utc.to_s,
            "Content-Type"=>"application/json; charset=UTF-8",
            "X-RateLimit-Limit"=>"50000",
            "X-RateLimit-Remaining"=>"49627",
            "X-RateLimit-Window"=>"24 hours",
            "X-RateLimit-Type"=>"global",
            "X-Response-Id"=>"j23jlk234jl2j34j",
            "X-LB"=>"dfw1-maas-prod-api0",
            "Vary"=>"Accept-Encoding",
            "Transfer-Encoding"=>"chunked"
          }
          response
        end
      end
    end
  end
end


