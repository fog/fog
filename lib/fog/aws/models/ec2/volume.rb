module Fog
  module AWS
    class EC2

      class Volume < Fog::Model

        attr_accessor :attachment_time,
          :availability_zone,
          :device,
          :instance_id
          :size,
          :snapshot_id,
          :status,
          :volume_id
        
        def initialize(attributes = {})
          if attributes['attachmentSet']
            attributes.merge!(attributes.delete('attachmentSet'))
          end
          remap_attributes(attributes, {
            'attachmentTime'    => :attachment_time,
            'availabilityZone'  => :availability_zone,
            'createTime'        => :create_time,
            'instanceId'        => :instance_id,
            'snapshotId'        => :snapshot_id,
            'status'            => :status
            'volumeId'          => :volume_id
          })
          super
        end

        def delete
          connection.delete_volume(@volume_id)
        end

        def save
          data = connection.create_volume(@availability_zone, @size, @snapshot_id).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          update_attributes(new_attributes)
          data
        end

      end

    end
  end
end
