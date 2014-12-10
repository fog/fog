require 'fog/core/model'
require 'fog/rackspace/models/compute_v2/meta_parent'

module Fog
  module Compute
    class RackspaceV2
      class Metadatum < Fog::Model
        include Fog::Compute::RackspaceV2::MetaParent

        identity :key
        attribute :value

        # Remove metadatum from server
        # @return [Boolean] return true if metadatum is deleting
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        def destroy
          requires :identity
          service.delete_metadata_item(collection_name, parent.id, key)
          true
        end

        # Save metadatum on server
        # @return [Boolean] return true if metadatum is saving
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        def save
          requires :identity, :value
          service.set_metadata_item(collection_name, parent.id, key, value)
          true
        end
      end
    end
  end
end
