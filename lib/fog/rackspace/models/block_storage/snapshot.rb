require 'fog/core/model'

module Fog
  module Rackspace
    class BlockStorage
      class Snapshot < Fog::Model
        AVAILABLE = 'available'
        CREATING = 'creating'
        DELETING = 'deleting'
        ERROR = 'error'
        ERROR_DELETING = 'error_deleting'

        # @!attribute [r] id
        # @return [String] The snapshot id
        identity :id

        # @!attribute [r] created_at
        # @return [String] snapshot creation time
        attribute :created_at, :aliases => 'createdAt'

        # @!attribute [r] state
        # @return [String] snapshot status
        attribute :state, :aliases => 'status'

        # @!attribute [rw] display_name
        # @return [String] display name of snapshot
        attribute :display_name

        # @!attribute [rw] display_description
        # @return [String] display description of snapshot
        attribute :display_description

        # @!attribute [rw] size
        # @return [String] size of snapshot
        attribute :size

        # @!attribute [rw] volume_id
        # @return [String] the volume_id of the snapshot
        attribute :volume_id

        # @!attribute [r] availability_zone
        # @return [String] region of the snapshot
        attribute :availability_zone

        # @!attribute [r] force
        # @return [Boolean] `force` creation flag
        attribute :force

        # Returns true if the snapshot is in a ready state
        # @return [Boolean] returns true if snapshot is in a ready state
        def ready?
          state == AVAILABLE
        end

        # Creates the snapshot
        # @param force [Boolean] Set to true to force service to create snapshot
        # @raise [Fog::Rackspace::BlockStorage::IdentifierTaken] if the snapshot has been previously saved.
        # @return [Boolean] returns true if snapshot is being created
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @note A snapshot object cannot be updated
        # @note All writes to the volume should be flushed before creating the snapshot, either by un-mounting any file systems on the volume or by detaching the volume.
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/POST_createSnapshot__v1__tenant_id__snapshots.html
        def save
          requires :volume_id
          raise IdentifierTaken.new('Resaving may cause a duplicate snapshot to be created') if persisted?
          data = service.create_snapshot(volume_id, {
            :display_name => display_name,
            :display_description => display_description,
            :force => force
          })
          merge_attributes(data.body['snapshot'])
          true
        end

        # Destroys snapshot
        # @return [Boolean] returns true if snapshot was deleted
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/DELETE_deleteSnapshot__v1__tenant_id__snapshots.html
        def destroy
          requires :identity
          service.delete_snapshot(identity)
          true
        end
      end
    end
  end
end
