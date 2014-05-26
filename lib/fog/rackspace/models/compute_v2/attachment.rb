require 'fog/core/model'

module Fog
  module Compute
    class RackspaceV2
      class Attachment < Fog::Model
        # @!attribute [r] server_id
        # @return [String] The server id
        attribute :server_id, :aliases => 'serverId'

        # @!attribute [r] volume_id
        # @return [String] The volume id
        attribute :volume_id, :aliases => 'volumeId'

        # @!attribute [r] device
        # @return [String]device name of the device /dev/xvd[a-p]
        attribute :device

        def initialize(new_attributes = {})
          super(new_attributes)
          server_id = server.id if server #server id should come from collection
          self
        end

        # Attaches volume to volume to server.
        # Requires :server_id, :volume_id, and device to be populated
        # @return [Boolean] true if volume is attaching
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Attach_Volume_to_Server.html
        def save
          requires :server_id, :volume_id, :device
          data = service.attach_volume(server_id, volume_id, device)
          merge_attributes(data.body['volumeAttachment'])
          true
        end

        # Detaches volume from server
        # @return [Boolean] true if volume is detaching
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Delete_Volume_Attachment.html
        def destroy
          requires :server_id, :volume_id
          service.delete_attachment(server_id, volume_id)
          true
        end
        alias_method :detach, :destroy

        private
        def server
          collection.server
        end
      end
    end
  end
end
