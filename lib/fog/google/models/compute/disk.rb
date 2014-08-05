require 'fog/core/model'

module Fog
  module Compute
    class Google
      class Disk < Fog::Model
        identity :name

        attribute :kind
        attribute :id
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :zone, :aliases => :zone_name
        attribute :status
        attribute :description
        attribute :size_gb, :aliases => 'sizeGb'
        attribute :self_link, :aliases => 'selfLink'
        attribute :source_image, :aliases => 'sourceImage'
        attribute :source_image_id, :aliases => 'sourceImageId'
        attribute :source_snapshot, :aliases => 'sourceSnapshot'
        attribute :source_snapshot_id, :aliases => 'sourceSnapshotId'
        attribute :type

        def save
          requires :name, :zone, :size_gb

          options = {}
          my_description = "Created with fog"
          if !source_image.nil?
            my_description = "Created from image: #{source_image}"
          end
          if source_image.nil? && !source_snapshot.nil?
            options['sourceSnapshot'] = source_snapshot
            my_description = "Created from snapshot: #{source_snapshot}"
          end

          options['sizeGb'] = size_gb
          options['description'] = description || my_description
          options['type'] = type

          data = service.insert_disk(name, zone, source_image, options)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async=true)
          requires :name, :zone

          data = service.delete_disk(name, zone_name)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
          unless async
            operation.wait_for { ready? }
          end
          operation
        end

        def zone_name
          zone.nil? ? nil : zone.split('/')[-1]
        end

        # auto_delete can only be applied to disks created before instance creation.
        # auto_delete = true will automatically delete disk upon instance termination.
        def get_object(writable=true, boot=false, device_name=nil, auto_delete=false)
          mode = writable ? 'READ_WRITE' : 'READ_ONLY'
          value = {
            'autoDelete' => auto_delete,
            'boot' => boot,
            'source' => self_link,
            'mode' => mode,
            'deviceName' => device_name,
            'type' => 'PERSISTENT'
          }.select { |k, v| !v.nil? }
          return Hash[value]
        end

        def get_as_boot_disk(writable=true, auto_delete=false)
          get_object(writable, true, nil, auto_delete)
        end

        def ready?
          self.status == RUNNING_STATE
        end

        def reload
          requires :identity, :zone

          return unless data = begin
            collection.get(identity, zone_name)
          rescue Excon::Errors::SocketError
            nil
          end

          new_attributes = data.attributes
          merge_attributes(new_attributes)
          self
        end

        def create_snapshot(snapshot_name, snapshot_description="")
          requires :name, :zone

          if snapshot_name.nil? or snapshot_name.empty?
            raise ArgumentError, 'Invalid snapshot name'
          end

          options = {
            'name'        => snapshot_name,
            'description' => snapshot_description,
          }

          data = service.insert_snapshot(name, zone_name, service.project, options)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
          operation.wait_for { !pending? }
          service.snapshots.get(snapshot_name)
        end

        RUNNING_STATE = "READY"
      end
    end
  end
end
