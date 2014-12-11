module Fog
  module Compute
    class RackspaceV2
      class Real
        # Deletes a specified volume attachment from a specified server instance.
        # @param [String] server_id id of server containing volume to delete
        # @param [String] volume_id id of volume on server to delete
        # @return [Excon::Response] response
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Delete_Volume_Attachment.html
        def delete_attachment(server_id, volume_id)
          request(
            :expects => [202],
            :method => 'DELETE',
            :path => "servers/#{server_id}/os-volume_attachments/#{volume_id}"
          )
        end
      end

      class Mock
        def delete_attachment(server_id, volume_id)
          volume     = self.data[:volumes][volume_id]
          server     = self.data[:servers][server_id]
          if volume.nil? || server.nil?
            raise Fog::Compute::RackspaceV2::NotFound
          else
            self.data[:volume_attachments].delete_if { |v| v["serverId"] == server_id && v["volumeId"] == volume_id }
            volume["attachments"].delete_if { |v| v["serverId"] == server_id && v["volumeId"] == volume_id }

            response(:status => 204)
          end
        end
      end
    end
  end
end
