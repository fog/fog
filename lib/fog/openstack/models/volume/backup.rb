require 'fog/core/model'

module Fog
  module Volume
    class OpenStack
      class Backup < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :status
        attribute :size
        attribute :container
        attribute :volume_id
        attribute :object_count
        attribute :availability_zone
        attribute :created_at
        attribute :fail_reason
        attribute :links

        def initialize(attributes)
          prepare_service_value(attributes)
          super
        end

        def save
          requires :volume_id
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          create
        end

        def create
          requires :volume_id
          merge_attributes(service.create_backup(self.volume_id,
                                                 self.attributes).body['backup'])
          self
        end

        def destroy
          requires :id
          service.delete_backup(self.id)
          true
        end
        
        def restore(volume_id)
          requires :id
          service.restore_backup(self.id, volume_id)
          true
        end

      end
    end
  end
end