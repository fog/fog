module Fog
  module Compute
    class OpenStack
      class Real

        def create_image(server_id, name, metadata={})
          body = { 'createImage' => {
            'name' => name,
            'metadata' => metadata
          }}
          server_action(server_id, body)
        end

      end

      class Mock

        def create_image(server_id, name, metadata={})
          response = Excon::Response.new
          response.status = 202
          response
        end

      end
    end
  end
end
