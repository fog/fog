module Fog
  module Compute
    class RackspaceV2
      class Real
        # This operation attaches a volume to the specified server.
        # @param [String] server_id
        # @param [String] volume_id
        # @param [String] device name of the device /dev/xvd[a-p]  (optional)
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * volumeAttachment [Hash]:
        #       * device [String] - The name of the device, such as /dev/xvdb. Specify auto for auto-assignment.
        #       * serverId [String] - The id of the server that attached the volume
        #       * id [String] - The id of the attachment
        #       * volumeId [String] - The id of the volume that was attached
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Attach_Volume_to_Server.html
        def attach_volume(server_id, volume_id, device)
          data = {
            'volumeAttachment' => {
              'volumeId' => volume_id
            }
          }

          data['volumeAttachment']['device'] = device if device

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
