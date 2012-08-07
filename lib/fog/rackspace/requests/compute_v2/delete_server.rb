module Fog
  module Compute
    class RackspaceV2
      class Real
        def delete_server(server_id)
          request(
            :expects => [204],
            :method => 'DELETE',
            :path => "servers/#{server_id}"
          )
        end
      end
    end
  end
end
