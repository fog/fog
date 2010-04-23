require 'fog/model'

module Fog
  module AWS
    module EC2

      class Volume < Fog::Model
        extend Fog::Deprecation
        deprecate(:status, :state)

        identity  :id,         'volumeId'

        attribute :attached_at,       'attachTime'
        attribute :availability_zone, 'availabilityZone'
        attribute :created_at,        'createTime'
        attribute :device
        attribute :server_id,         'instanceId'
        attribute :size
        attribute :snapshot_id,       'snapshotId'
        attribute :state,             'status'

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

        def server=(new_server)
          requires :device

          if new_server
            attach(new_server)
          else
            detach
          end
        end

        def save
          requires :availability_zone, :size

          data = connection.create_volume(@availability_zone, @size, @snapshot_id).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          if @server
            self.server = @server
          end
          true
        end

        def snapshots
          requires :id

          connection.snapshots(:volume => self)
        end

        private

        def attach(new_server)
          if new_record?
            @server = new_server
            @availability_zone = new_server.availability_zone
          elsif new_server
            @server = nil
            @server_id = new_server.id
            connection.attach_volume(@server_id, @id, @device)
          end
        end

        def detach
          @server = nil
          @server_id = nil
          unless new_record?
            connection.detach_volume(@id)
          end
        end

      end

    end
  end
end
