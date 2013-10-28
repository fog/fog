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
            self.unit_number = server.volumes.size
          end

          service.add_vm_volume(self)

          true
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
