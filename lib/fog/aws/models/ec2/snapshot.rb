module Fog
  module AWS
    class EC2

      class Snapshot < Fog::Model

        identity  :snapshot_id, 'snapshotId'

        attribute :progress
        attribute :start_time,  'startTime'
        attribute :status
        attribute :volume_id,    'volumeId'

        def destroy
          requires :snapshot_id

          connection.delete_snapshot(@snapshot_id)
          true
        end

        def save
          requires :volume_id

          data = connection.create_snapshot(@volume_id).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          true
        end

        def volume
          requires :snapshot_id

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
