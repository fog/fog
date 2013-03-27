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
        # @raise [Fog::Rackspace::Errors::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Errors::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Errors::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Errors::ServiceError]
        # @see Server#attachments
        def all
          data = service.list_attachments(server.id).body['volumeAttachments']
          load(data)
        end

        # Retrieves attachment belonging to server
        # @param [String] volume_id
        # @return [Fog::Compute::RackspaceV2::Attachment] attachment for volume id
        # @raise [Fog::Rackspace::Errors::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Errors::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Errors::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Errors::ServiceError]
        def get(volume_id)
          data = service.get_attachment(server.id, volume_id).body['volumeAttachment']
          data && new(data)
        end
      end
    end
  end
end
