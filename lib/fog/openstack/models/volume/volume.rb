require 'fog/openstack/models/model'

module Fog
  module Volume
    class OpenStack
      class Volume < Fog::OpenStack::Model
        identity :id

        attribute :display_name,        :aliases => 'displayName'
        attribute :display_description, :aliases => 'displayDescription'
        attribute :metadata
        attribute :status
        attribute :size
        attribute :volume_type,         :aliases => ['volumeType', 'type']
        attribute :snapshot_id,         :aliases => 'snapshotId'
        attribute :imageRef,            :aliases => 'image_id'
        attribute :availability_zone,   :aliases => 'availabilityZone'
        attribute :created_at,          :aliases => 'createdAt'
        attribute :attachments
        attribute :source_volid
        attribute :tenant_id,           :aliases => 'os-vol-tenant-attr:tenant_id'

        def save
          requires :display_name, :size
          data = service.create_volume(display_name, display_description, size, attributes)
          merge_attributes(data.body['volume'])
          true
        end

        def destroy
          requires :id
          service.delete_volume(id)
          true
        end

        def extend(size)
          requires :id
          service.extend_volume(id, size)
          true
        end

        def ready?
          status == 'available'
        end
      end
    end
  end
end
