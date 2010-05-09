require 'fog/model'

module Fog
  module AWS
    module EC2

      class Snapshot < Fog::Model
        extend Fog::Deprecation
        deprecate(:status, :state)

        identity  :id, 'snapshotId'

        attribute :description
        attribute :progress
        attribute :created_at,  'startTime'
        attribute :owner_id,    'ownerId'
        attribute :state,       'status'
        attribute :volume_id,   'volumeId'
        attribute :volume_size, 'volumeSize'

        def destroy
          requires :id

          connection.delete_snapshot(@id)
          true
        end

        def ready?
          state == 'completed'
        end

        def save
          requires :volume_id

          data = connection.create_snapshot(@volume_id).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          true
        end

        def volume
          requires :id

          connection.describe_volumes(@volume_id)
        end

        private

        def volume=(new_volume)
          @volume_id = new_volume.volume_id
        end

      end

    end
  end
end
