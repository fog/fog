require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/attachment'

module Fog
  module Compute
    class RackspaceV2
      class Attachments < Fog::Collection
        model Fog::Compute::RackspaceV2::Attachment

        attr_accessor :server

        # Retrieves attachments belonging to server
        # @return [Fog::Compute::RackspaceV2::Attachments] list of attachments
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see Server#attachments
        def all
          data = service.list_attachments(server.id).body['volumeAttachments']
          load(data)
        end

        # Retrieves attachment belonging to server
        # @param [String] volume_id
        # @return [Fog::Compute::RackspaceV2::Attachment] attachment for volume id
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        def get(volume_id)
          data = service.get_attachment(server.id, volume_id).body['volumeAttachment']
          data && new(data)
        end
      end
    end
  end
end
