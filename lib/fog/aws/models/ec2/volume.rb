module Fog
  module AWS
    class EC2

      class Volume < Fog::Model

        attribute :attach_time,       'attachTime'
        attribute :availability_zone, 'availabilityZone'
        attribute :create_time,       'createTime'
        attribute :device
        attribute :instance_id,       'instanceId'
        attribute :size
        attribute :snapshot_id,       'snapshotId'
        attribute :status
        attribute :volume_id,         'volumeId'
        
        def initialize(attributes = {})
          if attributes['attachmentSet']
            attributes.merge!(attributes.delete('attachmentSet').first || {})
          end
          super
        end

        def destroy
          connection.delete_volume(@volume_id)
          true
        end

        def instance=(new_instance)
          if !@volume_id
            @instance = new_instance
          elsif new_instance
            @instance = nil
            @instance_id = new_instance.instance_id
            connection.attach_volume(@instance_id, @volume_id, @device)
          end
        end

        def reload
          new_attributes = volumes.get(@volume_id).attributes
          merge_attributes(new_attributes)
        end

        def save
          data = connection.create_volume(@availability_zone, @size, @snapshot_id).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          if @instance
            self.instance = @instance
          end
          true
        end

        def snapshots
          connection.snapshots(:volume_id => volume_id)
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
