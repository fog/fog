module Fog
  module AWS
    class EC2

      class Volume < Fog::Model

        attribute :attachment_time,   'attachmentTime'
        attribute :availability_zone, 'availabilityZone'
        attribute :create_time,       'createTime'
        attribute :device
        attribute :instance_id,       'instanceId'
        attribute :size
        attribute :snapshot_id,       'snapshotId'
        attribute :status,            'status'
        attribute :volume_id,         'volumeId'
        
        def initialize(attributes = {})
          if attributes['attachmentSet']
            attributes.merge!(attributes.delete('attachmentSet'))
          end
          super
        end

        def destroy
          connection.delete_volume(@volume_id)
          true
        end

        def reload
          new_attributes = volumes.all(@volume_id).first.attributes
          merge_attributes(new_attributes)
        end

        def save
          data = connection.create_volume(@availability_zone, @size, @snapshot_id).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          update_attributes(new_attributes)
          true
        end

        def snapshots
          connection.snapshots.all.select {|snapshot| snapshot.volume_id == @volume_id}
        end

        def volumes
          @volumes
        end

        private

        def volumes=(new_volumes)
          @volumes = new_volumes
        end

      end

    end
  end
end
