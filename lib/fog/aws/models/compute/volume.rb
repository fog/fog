require 'fog/core/model'

module Fog
  module Compute
    class AWS

      class Volume < Fog::Model

        identity  :id,                    :aliases => 'volumeId'

        attribute :attached_at,           :aliases => 'attachTime'
        attribute :availability_zone,     :aliases => 'availabilityZone'
        attribute :created_at,            :aliases => 'createTime'
        attribute :delete_on_termination, :aliases => 'deleteOnTermination'
        attribute :device
        attribute :iops
        attribute :server_id,             :aliases => 'instanceId'
        attribute :size
        attribute :snapshot_id,           :aliases => 'snapshotId'
        attribute :state,                 :aliases => 'status'
        attribute :tags,                  :aliases => 'tagSet'
        attribute :type,                  :aliases => 'volumeType'

        def initialize(attributes = {})
          # assign server first to prevent race condition with persisted?
          self.server = attributes.delete(:server)
          super
        end

        def destroy
          requires :id

          service.delete_volume(id)
          true
        end

        def ready?
          state == 'available'
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :availability_zone
          requires_one :size, :snapshot_id

          if type == 'io1'
            requires :iops
          end

          data = service.create_volume(availability_zone, size, 'SnapshotId' => snapshot_id, 'VolumeType' => type, 'Iops' => iops).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)

          if tags = self.tags
            # expect eventual consistency
            Fog.wait_for { self.reload rescue nil }
            for key, value in (self.tags = tags)
              service.tags.create(
                :key          => key,
                :resource_id  => self.identity,
                :value        => value
              )
            end
          end

          if @server
            self.server = @server
          end
          true
        end

        def server
          requires :server_id
          service.servers('instance-id' => server_id)
        end

        def server=(new_server)
          if new_server
            attach(new_server)
          else
            detach
          end
        end

        def snapshots
          requires :id
          service.snapshots(:volume => self)
        end

        def snapshot(description)
          requires :id
          service.create_snapshot(id, description)
        end

        def force_detach
          detach(true)
        end

        private

        def attachmentSet=(new_attachment_set)
          merge_attributes(new_attachment_set.first || {})
        end

        def attach(new_server)
          if !persisted?
            @server = new_server
            self.availability_zone = new_server.availability_zone
          elsif new_server
            requires :device
            wait_for { ready? }
            @server = nil
            self.server_id = new_server.id
            service.attach_volume(server_id, id, device)
            reload
          end
        end

        def detach(force = false)
          @server = nil
          self.server_id = nil
          if persisted?
            service.detach_volume(id, 'Force' => force)
            reload
          end
        end

      end
    end
  end
end
