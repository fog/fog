module Fog
  module Compute
    class RackspaceV2
      class Real
        def delete_attachment(server_id, volume_id)
          request(
            :expects => [202],
            :method => 'DELETE',
            :path => "servers/#{server_id}/os-volume_attachments/#{volume_id}"
          )
        end
      end
    end
  end
end
