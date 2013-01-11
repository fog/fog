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

      class Mock
        def attach_volume(server_id, volume_id, device)
          volume = self.data[:volumes][volume_id]
          server = self.data[:servers][server_id]

          if server.nil? || volume.nil?
            raise Fog::Compute::RackspaceV2::NotFound
          else
            self.data[:volume_attachments] << {
              "device"   => device,
              "serverId" => server_id,
              "volumeId" => volume_id,
              "id"       => volume_id,
            }

            volume["attachments"] << {
              "volumeId" => volume_id,
              "serverId" => server_id,
              "device"   => device,
              "id"       => volume_id,
            }

            body = {
              "volumeAttachment" => {
                "serverId" => server_id,
                "volumeId" => volume_id,
                "device"   => device,
                "id"       => volume_id,
              }
            }

            volume["status"] = "in-use"

            response(:body => body)
          end
        end
      end
    end
  end
end
