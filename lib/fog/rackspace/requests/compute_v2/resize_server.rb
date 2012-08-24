module Fog
  module Compute
    class RackspaceV2
      class Real
        def resize_server(server_id, flavor_id)
          data = {
            'resize' => {
              'flavorRef' => flavor_id
            }
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
