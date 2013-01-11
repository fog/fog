module Fog
  module Compute
    class RackspaceV2
      class Real
        def get_attachment(server_id, volume_id)
          request(
            :expects => [200, 203, 300],
            :method => 'GET',
            :path => "servers/#{server_id}/os-volume_attachments/#{volume_id}"
          )
        end
      end

      class Mock
        def get_attachment(server_id, volume_id)
          attachment = self.data[:volume_attachments].detect { |v| v["serverId"] == server_id && v["volumeId"] == volume_id }

          response(:body => {"volumeAttachment" => attachment})
        end
      end
    end
  end
end
