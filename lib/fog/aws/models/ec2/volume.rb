module Fog
  module AWS
    class EC2

      class Volume < Fog::Model

        identity  :id,         'volumeId'

        attribute :attach_time,       'attachTime'
        attribute :availability_zone, 'availabilityZone'
        attribute :create_time,       'createTime'
        attribute :device
        attribute :instance_id,       'instanceId'
        attribute :size
        attribute :snapshot_id,       'snapshotId'
        attribute :status
        
        def initialize(attributes = {})
          if attributes['attachmentSet']
            attributes.merge!(attributes.delete('attachmentSet').first || {})
          end
          super
        end

        def destroy
          requires :id

          connection.delete_volume(@id)
          true
        end

        def instance=(new_instance)
          if new_instance
            attach(new_instance)
          else
            detach
          end
        end

        def save
          requires :availability_zone, :size

          data = connection.create_volume(@availability_zone, @size, @snapshot_id).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          if @instance
            self.instance = @instance
          end
          true
        end

        def snapshots
          requires :id

          connection.snapshots(:volume => self)
        end

        private

        def attach(new_instance)
          if new_record?
            @instance = new_instance
            @availability_zone = new_instance.availability_zone
          elsif new_instance
            @instance = nil
            @instance_id = new_instance.id
            connection.attach_volume(@instance_id, @id, @device)
          end
        end

        def detach
          @instance = nil
          @instance_id = nil
          unless new_record?
            connection.detach_volume(@id)
          end
        end

      end

    end
  end
end
