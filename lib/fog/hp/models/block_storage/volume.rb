require 'fog/core/model'

module Fog
  module HP
    class BlockStorage
      class Volume < Fog::Model
        identity  :id

        attribute :name,                 :aliases => 'displayName'
        attribute :description,          :aliases => 'displayDescription'
        attribute :size
        attribute :status
        attribute :type,                 :aliases => 'volumeType'
        attribute :created_at,           :aliases => 'createdAt'
        attribute :availability_zone,    :aliases => 'availabilityZone'
        attribute :snapshot_id,          :aliases => 'snapshotId'
        attribute :source_image_id,      :aliases => 'sourceImageRef'   # only for bootable volumes
        attribute :attachments
        attribute :metadata

        attr_reader :server_id
        attr_reader :device

        def initialize(attributes = {})
          # assign these attributes first to prevent race condition with new_record?
          self.image_id = attributes.delete(:image_id)
          super
        end

        def device
          attachments[0]['device'] if has_attachments?
        end

        def server_id
          attachments[0]['serverId'] if has_attachments?
        end

        # used for creating bootable volumes
        def image_id=(new_image_id)
          @image_id = new_image_id
        end

        # a volume can be attached to only one server at a time
        def has_attachments?
          !(attachments.nil? || attachments.empty? || attachments[0].empty?)
        end

        def in_use?
          self.status == 'in-use'
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
            service.compute.detach_volume(server_id, id)
          end
          true
        end

        def destroy
          requires :id
          service.delete_volume(id)
          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :name, :size
          options = {
            'metadata'          => metadata,
            'snapshot_id'       => snapshot_id,
            'imageRef'          => @image_id
          }
          options = options.reject {|key, value| value.nil?}
          data = service.create_volume(name, description, size, options)
          merge_attributes(data.body['volume'])
          true
        end
      end
    end
  end
end
