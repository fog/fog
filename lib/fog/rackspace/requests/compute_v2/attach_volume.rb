module Fog
  module Compute
    class RackspaceV2
      class Real
        def attach_volume(server_id, volume_id, device)
          data = {
            'volumeAttachment' => {
              'volumeId' => volume_id,
              'device' => device
            }
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => [200],
            :method => 'POST',
            :path => "servers/#{server_id}/os-volume_attachments"
          )
        end
      end
    end
  end
end
