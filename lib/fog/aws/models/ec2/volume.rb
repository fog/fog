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

        def delete
          connection.delete_volume(@volume_id)
          true
        end

        def save
          data = connection.create_volume(@availability_zone, @size, @snapshot_id).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          update_attributes(new_attributes)
          true
        end

        def snapshots
          @snapshots ||= begin
            Fog::AWS::S3::Snapshots.new(
              :connection => connection,
              :volume     => self
            )
          end
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
