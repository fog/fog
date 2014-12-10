require 'fog/core/model'

module Fog
  module Rackspace
    class BlockStorage
      class Volume < Fog::Model
        AVAILABLE = 'available'
        ATTACHING = 'attaching'
        CREATING = 'creating'
        DELETING = 'deleting'
        ERROR = 'error'
        ERROR_DELETING = 'error_deleting'
        IN_USE = 'in-use'

        # @!attribute [r] id
        # @return [String] The volume id
        identity :id

        # @!attribute [r] created_at
        # @return [String] volume creation date
        attribute :created_at, :aliases => 'createdAt'

        # @!attribute [r] state
        # @return [String] volume status
        attribute :state, :aliases => 'status'

        # @!attribute [rw] display_name
        # @return [String] display name of volume
        attribute :display_name

        # @!attribute [rw] display_description
        # @return [String] display description of volume
        attribute :display_description

        # @!attribute [rw] size
        # @return [String] size of the volume in GB (100 GB minimum)
        attribute :size

        # @!attribute [r] attachments
        # @return [Array<Hash>] returns an array of hashes containing attachment information
        attribute :attachments

        # @!attribute [rw] volume_type
        # @return [String] type of volume
        attribute :volume_type

        # @!attribute [r] availability_zone
        # @return [String] region of the volume
        attribute :availability_zone

        # @!attribute [rw] image_id
        # @return [String] The ID of an image used to create a bootable volume.
        attribute :image_id, :aliases => ['image', 'imageRef'], :squash => 'id'

        # Returns true if the volume is in a ready state
        # @return [Boolean] returns true if volume is in a ready state
        def ready?
          state == AVAILABLE
        end

        # Returns true if the volume is attached
        # @return [Boolean] true if the volume is attached
        def attached?
          state == IN_USE
        end

        # Returns a list of snapshots associated with the volume
        # @return [Fog::Rackspace::BlockStorage::Snapshots]
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        def snapshots
          service.snapshots.select { |s| s.volume_id == identity }
        end

        # Creates a snapshot from the current volume
        # @param [Hash] options
        # @option options [String] :display_name of snapshot
        # @option options [String] :display_description of snapshot
        # @option options [Boolean] :force - If set to true, snapshot will be taken even if volume is still mounted.
        # @return [Fog::Rackspace::BlockStorage::Snapshot]
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @note All writes to the volume should be flushed before creating the snapshot, either by un-mounting any file systems on the volume or by detaching the volume.
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/POST_createSnapshot__v1__tenant_id__snapshots.html
        def create_snapshot(options={})
          requires :identity
          service.snapshots.create(options.merge(:volume_id => identity))
        end

        # Creates volume
        # @raise [Fog::Rackspace::BlockStorage::IdentifierTaken] if the volume has been previously saved.
        # @return [Boolean] returns true if volume was successfully created
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @note A volume object cannot be updated
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/POST_createVolume__v1__tenant_id__volumes.html
        def save
          requires :size
          raise IdentifierTaken.new('Resaving may cause a duplicate volume to be created') if persisted?
          data = service.create_volume(size, {
            :display_name => display_name,
            :display_description => display_description,
            :volume_type => volume_type,
            :availability_zone => availability_zone,
            :snapshot_id => attributes[:snapshot_id],
            :image_id => attributes[:image_id]
          })
          merge_attributes(data.body['volume'])
          true
        end

        # Destroys Volume
        # @return [Boolean] returns true if volume was deleted
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @note You cannot delete a volume until all of its dependent snaphosts have been deleted.
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/DELETE_deleteVolume__v1__tenant_id__volumes.html
        def destroy
          requires :identity
          service.delete_volume(identity)
          true
        end
      end
    end
  end
end
