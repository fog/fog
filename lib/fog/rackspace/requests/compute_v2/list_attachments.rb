module Fog
  module Compute
    class RackspaceV2
      class Real
        def list_attachments(server_id)
          request(
            :expects => [200, 203, 300],
            :method => 'GET',
            :path => "servers/#{server_id}/os-volume_attachments"
          )
        end
      end

      class Mock
        def list_attachments(server_id)
          volumes_array = self.data[:volume_attachments].select { |va| va["serverId"] == server_id }
          response(:body => {"volumeAttachments" => volumes_array})
        end
      end
    end
  end
end
