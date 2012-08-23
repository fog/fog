require 'fog/core/model'

module Fog
  module Rackspace
    class BlockStorage
      class Snapshot < Fog::Model
        AVAILABLE = 'available'
        CREATING = 'creating'
        DELETING = 'deleting'
        ERROR = 'error'
        ERROR_DELETING = 'error_deleting'

        identity :id

        attribute :created_at, :aliases => 'createdAt'
        attribute :state, :aliases => 'status'
        attribute :display_name
        attribute :display_description
        attribute :size
        attribute :volume_id
        attribute :availability_zone

        def ready?
          state == AVAILABLE
        end

        def save(force = false)
          requires :volume_id
          data = connection.create_snapshot(volume_id, {
            :display_name => display_name,
            :display_description => display_description,
            :force => force
          })
          merge_attributes(data.body['snapshot'])
          true
        end

        def destroy
          requires :identity
          connection.delete_snapshot(identity)
          true
        end
      end
    end
  end
end
