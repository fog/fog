require 'fog/core/model'

module Fog
  module HP
    class BlockStorageV2
      class VolumeBackup < Fog::Model
        identity  :id

        attribute :name
        attribute :description
        attribute :size
        attribute :status
        attribute :created_at
        attribute :availability_zone
        attribute :volume_id
        attribute :container
        attribute :fail_reason
        attribute :object_count
        attribute :links

        def restoring?
          self.status == 'restoring'
        end

        def ready?
          self.status == 'available'
        end

        def restore(volume_id=nil)
          requires :id
          if volume_id
            service.restore_volume_backup(id, :volume_id => volume_id)
          else
            service.restore_volume_backup(id)
          end
          true
        end

        def destroy
          requires :id
          service.delete_volume_backup(id)
          true
        end

        def save
          requires :volume_id
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          merge_attributes(service.create_volume_backup(volume_id, attributes).body['backup'])
          true
        end
      end
    end
  end
end
