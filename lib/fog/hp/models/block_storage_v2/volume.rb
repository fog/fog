require 'fog/core/model'

module Fog
  module HP
    class BlockStorageV2
      class Volume < Fog::Model
        identity  :id

        attribute :name,                 :aliases => 'display_name'
        attribute :description,          :aliases => 'display_description'
        attribute :size
        attribute :status
        attribute :type,                 :aliases => 'volume_type'
        attribute :created_at
        attribute :availability_zone
        attribute :snapshot_id
        attribute :source_volid
        attribute :attachments
        attribute :metadata
        attribute :bootable
        attribute :image_metadata,       :aliases => 'volume_image_metadata'

        def initialize(attributes = {})
          # assign these attributes first to prevent race condition with new_record?
          self.image_id = attributes.delete(:image_id)
          super
        end

        # a volume can be attached to only one server at a time
        def device
          attachments[0]['device'] if has_attachments?
        end

        # a volume can be attached to only one server at a time
        def server_id
          attachments[0]['server_id'] if has_attachments?
        end

        # used for creating bootable volumes
        def image_id=(new_image_id)
          @image_id = new_image_id
        end

        def image_id
          @image_id = image_metadata['image_id'] if image_metadata
        end

        # a volume can be attached to only one server at a time
        def has_attachments?
          !(attachments.nil? || attachments.empty? || attachments[0].empty?)
        end

        def in_use?
          self.status == 'in-use'
        end
        alias_method :attached?, :in_use?

        def backing_up?
          self.status == 'backing-up'
        end

        def restoring?
          self.status == 'restoring-backup'
        end

        def ready?
          self.status == 'available'
        end

        # volume can be attached to only one server at a time
        def attach(new_server_id, device)
          requires :id
          unless in_use?
            data = service.compute.attach_volume(new_server_id, id, device)
            merge_attributes(:attachments => attachments << data.body['volumeAttachment'])
            true
          else
            false
          end
        end

        def detach
          requires :id
          if has_attachments?
            service.compute.detach_volume(self.server_id, id)
          end
          true
        end

        def destroy
          requires :id
          service.delete_volume(id)
          true
        end

        def save
          identity ? update : create
        end

        private

        def create
          options = {
            'display_name'        => name,
            'display_description' => description,
            'size'                => size,
            'metadata'            => metadata,
            'snapshot_id'         => snapshot_id,
            'imageRef'            => @image_id,
            'availability_zone'   => availability_zone,
            'source_volid'        => source_volid,
            'volume_type'         => type                 # this parameter is currently ignored
          }
          options = options.reject {|_, value| value.nil?}
          data = service.create_volume(options)
          merge_attributes(data.body['volume'])
          true
        end

        def update
          requires :id
          options = {
            'display_name'        => name,
            'display_description' => description,
            'metadata'            => metadata
          }
          options = options.reject {|_, value| value.nil?}
          data = service.update_volume(id, options)
          merge_attributes(data.body['volume'])
          true
        end
      end
    end
  end
end
