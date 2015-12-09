require 'fog/openstack/models/model'

module Fog
  module Volume
    class OpenStack
      class Volume < Fog::OpenStack::Model
        attribute :metadata
        attribute :status
        attribute :size
        attribute :volume_type, :aliases => ['volumeType', 'type']
        attribute :snapshot_id, :aliases => 'snapshotId'
        attribute :imageRef, :aliases => 'image_id'
        attribute :availability_zone, :aliases => 'availabilityZone'
        attribute :created_at, :aliases => 'createdAt'
        attribute :attachments
        attribute :source_volid

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