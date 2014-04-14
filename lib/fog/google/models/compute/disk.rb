require 'fog/core/model'

module Fog
  module Compute
    class Google

      class Disk < Fog::Model

        identity :name

        attribute :kind, :aliases => 'kind'
        attribute :id, :aliases => 'id'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :zone_name, :aliases => 'zone'
        attribute :status, :aliases => 'status'
        attribute :description, :aliases => 'description'
        attribute :size_gb, :aliases => 'sizeGb'
        attribute :self_link, :aliases => 'selfLink'
        attribute :source_image, :aliases => 'sourceImage'
        attribute :source_snapshot, :aliases => 'sourceSnapshot'
        attribute :source_snapshot_id, :aliases => 'sourceSnapshot'

        def save
          requires :name
          requires :zone_name

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

          data = service.insert_disk(name, zone_name, source_image, options).body
          data = service.backoff_if_unfound {service.get_disk(name, zone_name).body}
          service.disks.merge_attributes(data)
        end

        def destroy(async=true)
          requires :name, :zone_name
          operation = service.delete_disk(name, zone_name)
          # wait until "DONE" to ensure the operation doesn't fail, raises exception on error
          if not async
            Fog.wait_for do
              operation = service.get_zone_operation(zone_name, operation.body["name"])
              operation.body["status"] == "DONE"
            end
          end
          operation
        end

        def zone
          if self.zone_name.is_a? String
            service.get_zone(self.zone_name.split('/')[-1]).body["name"]
          elsif zone_name.is_a? Excon::Response
            service.get_zone(zone_name.body["name"]).body["name"]
          else
            self.zone_name
          end
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
          requires :identity
          requires :zone_name

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
          requires :name
          requires :zone_name

          if snapshot_name.nil? or snapshot_name.empty?
            raise ArgumentError, 'Invalid snapshot name'
          end

          options = {
            'name'        => snapshot_name,
            'description' => snapshot_description,
          }

          service.insert_snapshot(name, self.zone, service.project, options)
          data = service.backoff_if_unfound {
            service.get_snapshot(snapshot_name, service.project).body
          }
          service.snapshots.merge_attributes(data)

          # Try to return the representation of the snapshot we created
          service.snapshots.get(snapshot_name)
        end

        RUNNING_STATE = "READY"

      end
    end
  end
end
