module Fog
  module Compute
    class OpenStack
      class Real

        def rebuild_server(server_id, name, metadata=nil, personality=nil)

          body = { 'rebuild' => {
            'name' => name
          }}
          body['rebuild']['metadata'] = metadata if metadata
          body['rebuild']['personality'] = personality if personality
          #NOTE: the implementation returns 200 on rebuild
          server_action(server_id, body, 200)
        end

      end

      class Mock

        def rebuild_server(server_id, name, metadata, personality)
          response = Excon::Response.new
          response.status = 202
          response
        end

      end
    end
  end
end
