require 'fog/core/model'

module Fog
  module Volume
    class OpenStack
      class Volume < Fog::Model
        identity :id

        attribute :display_name,        :aliases => 'displayName'
        attribute :display_description, :aliases => 'displayDescription'
        attribute :status
        attribute :size
        attribute :volume_type,         :aliases => ['volumeType', 'type']
        attribute :snapshot_id,         :aliases => 'snapshotId'
        attribute :availability_zone,   :aliases => 'availabilityZone'
        attribute :created_at,          :aliases => 'createdAt'
        attribute :attachments
        attribute :metadata
        attribute :source_volid
        attribute :bootable
        attribute :host,                :aliases => 'os-vol-host-attr:host'
        attribute :tenant_id,           :aliases => 'os-vol-tenant-attr:tenant_id'

        def initialize(attributes)
          prepare_service_value(attributes)
          super
        end

        def save
          requires :display_name, :display_description, :size
          identity ? update : create
        end

        def create
          requires :display_name, :display_description, :size
          merge_attributes(service.create_volume(self.display_name,
                                                 self.display_description,
                                                 self.size, 
                                                 self.attributes).body['volume'])
          self
        end

        def update
          requires :id, :display_name, :display_description, :size
          merge_attributes(service.update_volume(self.id,
                                                 self.attributes).body['volume'])
          self
        end        
        
        def destroy
          requires :id
          service.delete_volume(self.id)
          true
        end

      end
    end
  end
end