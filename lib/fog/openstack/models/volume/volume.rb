require 'fog/openstack/models/model'

module Fog
  module Volume
    class OpenStack
      class Volume < Fog::OpenStack::Model
        identity :id

        attribute :name,                :aliases => ['display_name', 'displayName', :display_name]
        attribute :description,         :aliases => ['display_description', 'displayDescription', :display_description]
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

        # NOTE: The attributes "name" and "description" are called
        # "display_name" and "display_description" in API version v1.
        alias_method :display_name,         :name
        alias_method :display_name=,        :name=
        alias_method :display_description,  :description
        alias_method :display_description=, :description=

        def save
          requires :name, :size
          data = service.create_volume(name, description, size, attributes)
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
