require 'fog/core/model'

module Fog
  module Compute
    class RackspaceV2
      class Image < Fog::Model
        UNKNOWN = 'UNKNOWN'
        ACTIVE = 'ACTIVE'
        SAVING = 'SAVING'
        ERROR = 'ERROR'
        DELETED = 'DELETED'

        # @!attribute [r] id
        # @return [String] The server id
        identity :id

        # @!attribute [r] name
        # @return [String] The image name.
        attribute :name

        # @!attribute [r] created
        # @return [String] The time stamp for the creation date.
        attribute :created

        # @!attribute [r] updated
        # @return [String] The time stamp for the last update.
        attribute :updated

        # @!attribute [r] state
        # @return [String] image status.
        attribute :state, :aliases => 'status'

        # @!attribute [r] user_id
        # @return [String] The user Id.
        attribute :user_id

        # @!attribute [r] tenant_id
        # @return [String] The tenant Id.
        attribute :tenant_id

        # @!attribute [r] progress
        # @return [Fixnum] The build completion progress, as a percentage. Value is from 0 to 100.
        attribute :progress

        attribute :minDisk
        attribute :minRam

        # @!attribute [rw] disk_config
        # @return [String<AUTO, MANUAL>] The disk configuration value.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ch_extensions.html#diskconfig_attribute
        #
        # The disk configuration value.
        #   * AUTO -   The server is built with a single partition the size of the target flavor disk. The file system is automatically adjusted to fit the entire partition.
        #              This keeps things simple and automated. AUTO is valid only for images and servers with a single partition that use the EXT3 file system.
        #              This is the default setting for applicable Rackspace base images.
        #
        #   * MANUAL - The server is built using whatever partition scheme and file system is in the source image. If the target flavor disk is larger,
        #              the remaining disk space is left unpartitioned. This enables images to have non-EXT3 file systems, multiple partitions,
        #              and so on, and enables you to manage the disk configuration.
        attribute :disk_config, :aliases => 'OS-DCF:diskConfig'

        # @!attribute [r] links
        # @return [Array] image links.
        attribute :links

        def initialize(attributes={})
          @service = attributes[:service]
          super
        end

        # Image metadata
        # @return [Fog::Compute::RackspaceV2::Metadata] Collection of Fog::Compute::RackspaceV2::Metadatum objects containing metadata key value pairs.
        def metadata
          @metadata ||= begin
            Fog::Compute::RackspaceV2::Metadata.new({
              :service => service,
              :parent => self
            })
          end
        end

        # Set server metadata
        # @param [Hash] hash contains key value pairs
        def metadata=(hash={})
          metadata.from_hash(hash)
        end

        # Is image is in ready state
        # @param [String] ready_state By default state is ACTIVE
        # @param [Array,String] error_states By default state is ERROR
        # @return [Boolean] returns true if server is in a ready state
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @raise [Fog::Compute::RackspaceV2::InvalidImageStateException] if server state is an error state
        def ready?(ready_state = ACTIVE, error_states=[ERROR])
          if error_states
            error_states = Array(error_states)
            raise InvalidImageStateException.new(ready_state, state) if error_states.include?(state)
          end
          state == ready_state
        end

        # Destroy image
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        def destroy
          requires :identity
          service.delete_image(identity)
        end
      end
    end
  end
end
