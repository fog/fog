module Fog
  module Compute
    class RackspaceV2
      class Real
        def revert_resize_server(server_id)
          data = {
            'revertResize' => nil
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => [202],
            :method => 'POST',
            :path => "servers/#{server_id}/action"
          )
        end
      end
    end
  end
end
