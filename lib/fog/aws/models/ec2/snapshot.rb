module Fog
  module AWS
    class EC2

      class Snapshot < Fog::Model

        attribute :progress
        attribute :snapshot_id, 'snapshotId'
        attribute :start_time,  'startTime'
        attribute :status
        attribute :volume_id,    'volumeId'

        def destroy
          connection.delete_snapshot(@snapshot_id)
          true
        end

        def reload
          new_attributes = snapshots.get(@snapshot_id).attributes
          merge_attributes(new_attributes)
        end

        def save
          data = connection.create_snapshot(volume_id).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          true
        end

        def snapshots
          @snapshots
        end

        def volume
          connection.describe_volumes(@volume_id)
        end

        private

        def snapshots=(new_snapshots)
          @snapshots = new_snapshots
        end

        def volume=(new_volume)
          @volume_id = new_volume.volume_id
        end

      end

    end
  end
end
