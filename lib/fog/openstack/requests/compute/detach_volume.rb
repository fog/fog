module Fog
  module Compute
    class OpenStack
      class Real

        def detach_volume(server_id, attachment_id)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "servers/%s/os-volume_attachments/%s" % [server_id, attachment_id]
          )
        end

      end

      class Mock
      end

    end
  end
end
