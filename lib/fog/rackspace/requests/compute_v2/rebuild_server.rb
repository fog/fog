module Fog
  module Compute
    class RackspaceV2
      class Real
        def rebuild_server(server_id, image_id)
          data = {
            'rebuild' => {
              'imageRef' => image_id
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
