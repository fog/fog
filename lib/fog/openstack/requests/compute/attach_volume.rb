module Fog
  module Compute
    class OpenStack
      class Real

        def attach_volume(volume_id, server_id, device)
          data = {
            'volumeAttachment' => {
              'volumeId' => volume_id.to_s,
              'device'   => device
            }
          }
          request(
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => "servers/%s/os-volume_attachments" % [server_id]
          )
        end

      end

      class Mock
      end

    end
  end
end
