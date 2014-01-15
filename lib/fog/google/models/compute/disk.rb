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
          requires :name, :zone_name

          options = {}
          if source_image.nil? && !source_snapshot.nil?
            options['sourceSnapshot'] = source_snapshot
          end

          options['sizeGb'] = size_gb

          response = service.insert_disk(name, zone_name, source_image, options)
          operation = service.operations.new(response.body)
          operation.wait_for { ready? }

          data = service.backoff_if_unfound { service.get_disk(name, zone_name).body }

          self.merge_attributes(data)

          self
        end

        def destroy
          requires :name, :zone_name
          operation = service.operations.new(service.delete_disk(name, zone_name).body)
          operation 
        end
        alias_method :delete, :destroy

        def zone
          if self.zone_name.is_a? String
            service.get_zone(self.zone_name.split('/')[-1]).body["name"]
          elsif zone_name.is_a? Excon::Response
            service.get_zone(zone_name.body["name"]).body["name"]
          else
            self.zone_name
          end
        end

        def get_object(writable=true, boot=false, device_name=nil)
          mode = writable ? 'READ_WRITE' : 'READ_ONLY'
          return {
            'boot' => boot,
            'source' => self_link,
            'mode' => mode,
            'deviceName' => device_name,
            'type' => 'PERSISTENT'
          }.select { |k, v| !v.nil? }
        end

        def get_as_boot_disk(writable=true)
          get_object(writable, true)
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

        def create_snapshot(snapshot_name, snapshot_description = '')
          requires :name, :zone_name

          if snapshot_name.nil? || snapshot_name.empty?
            raise(ArgumentError, 'Invalid snapshot name')
          end

          options = {
            'name'        => snapshot_name,
            'description' => snapshot_description
          }

          response = service.insert_snapshot(name, zone_name, options)
          operation = service.operations.new(response.body)
          operation.wait_for { ready? }

          response = service.backoff_if_unfound { service.get_snapshot(snapshot_name) }
          attributes = response.body
          snapshot = service.snapshots.new(attributes)
          snapshot
        end

        RUNNING_STATE = 'READY'

      end
    end
  end
end
