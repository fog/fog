module Fog
  module Compute
    class RackspaceV2
      class Real
        
        # Retrieves attachment
        # @param [String] server_id
        # @param [String] volume_id
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * volumeAttachment [Hash]:
        #       * device [String] - The name of the device, such as /dev/xvdb. Specify auto for auto-assignment.
        #       * serverId [String] - The id of the server that attached the volume
        #       * id [String] - The id of the attachment
        #       * volumeId [String] - The id of the volume that was attached
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Get_Volume_Attachment_Details.html
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
