module Fog
  module Compute
    class Vsphere

      class Volume < Fog::Model
        DISK_SIZE_TO_GB = 1048576
        identity :id

        attribute :datastore
        attribute :mode
        attribute :size
        attribute :thin
        attribute :eager_zero
        attribute :name
        attribute :filename
        attribute :size_gb
        attribute :key
        attribute :unit_number
        attribute :server_id

        def initialize(attributes={} )
          # Assign server first to prevent race condition with persisted?
          self.server_id = attributes.delete(:server_id)

          super defaults.merge(attributes)
        end

        def size_gb
          attributes[:size_gb] ||= attributes[:size].to_i / DISK_SIZE_TO_GB if attributes[:size]
        end

        def size_gb= s
          attributes[:size] = s.to_i * DISK_SIZE_TO_GB if s
        end

        def to_s
          name
        end

        def destroy
          requires :server_id, :key, :unit_number

          service.destroy_vm_volume(self)
          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :server_id, :size, :datastore

          if unit_number.nil?
            used_unit_numbers = server.volumes.collect { |volume| volume.unit_number }
            max_unit_number = used_unit_numbers.max

            if max_unit_number > server.volumes.size
              # If the max ID exceeds the number of volumes, there must be a hole in the range. Find a hole and use it.
              self.unit_number = max_unit_number.times.to_a.find { |i| used_unit_numbers.exclude?(i) }
            else
              self.unit_number = max_unit_number + 1
            end
          else
            if server.volumes.any? { |volume| volume.unit_number == self.unit_number && volume.id != self.id }
              raise "A volume already exists with that unit_number, so we can't save the new volume"
            end
          end

          data = service.add_vm_volume(self)

          if data['task_state'] == 'success'
            # We have to query vSphere to get the volume attributes since the task handle doesn't include that info.
            created = server.volumes.all.find { |volume| volume.unit_number == self.unit_number }

            self.id = created.id
            self.key = created.key
            self.filename = created.filename

            true
          else
            false
          end
        end

        def server
          requires :server_id
          service.servers.get(server_id)
        end

        private

        def defaults
          {
            :thin => true,
            :name => "Hard disk",
            :mode => "persistent"
          }
        end
      end
    end
  end
end
