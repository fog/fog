module Fog
  module Compute
    class RackspaceV2
      class Real
        # Retrieves list of attached volumes
        # @param [String] server_id
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * volumeAttachment [Array]:
        #       * [Hash]:
        #         * device [String] - The name of the device, such as /dev/xvdb. Specify auto for auto-assignment.
        #         * serverId [String] - The id of the server that attached the volume
        #         * id [String] - The id of the attachment
        #         * volumeId [String] - The id of the volume that was attached
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Volume_Attachments.html
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
