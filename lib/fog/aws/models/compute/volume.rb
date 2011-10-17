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
        attribute :server_id,             :aliases => 'instanceId'
        attribute :size
        attribute :snapshot_id,           :aliases => 'snapshotId'
        attribute :state,                 :aliases => 'status'
        attribute :tags,                  :aliases => 'tagSet'

        def initialize(attributes = {})
          # assign server first to prevent race condition with new_record?
          self.server = attributes.delete(:server)
          super
        end

        def destroy
          requires :id

          connection.delete_volume(id)
          true
        end

        def ready?
          state == 'available'
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :availability_zone
          requires_one :size, :snapshot_id

          data = connection.create_volume(availability_zone, size, snapshot_id).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          if @server
            self.server = @server
          end
          true
        end

        def server
          requires :server_id
          connection.servers('instance-id' => server_id)
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
          connection.snapshots(:volume => self)
        end

        def snapshot(description)
          requires :id
          connection.create_snapshot(id, description)
        end

        def force_detach
          detach(true)
        end

        private

        def attachmentSet=(new_attachment_set)
          merge_attributes(new_attachment_set.first || {})
        end

        def attach(new_server)
          if new_record?
            @server = new_server
            self.availability_zone = new_server.availability_zone
          elsif new_server
            requires :device
            @server = nil
            self.server_id = new_server.id
            connection.attach_volume(server_id, id, device)
            reload
          end
        end

        def detach(force = false)
          @server = nil
          self.server_id = nil
          unless new_record?
            connection.detach_volume(id, 'Force' => force)
            reload
          end
        end

      end

    end
  end
end
