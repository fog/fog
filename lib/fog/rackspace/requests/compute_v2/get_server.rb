module Fog
  module Compute
    class RackspaceV2
      class Real
        def get_server(server_id)
          request(
            :expects => [200, 203, 300],
            :method => 'GET',
            :path => "servers/#{server_id}"
          )
        end
      end
    end
  end
end
