require 'fog/core/model'

module Fog
  module Compute
    class VirtualBox

      class StorageController < Fog::Model

        identity :name

        attribute :bootable
        attribute :bus
        attribute :controller_type
        attribute :instance
        attribute :max_devices_per_port_count
        attribute :max_port_count
        attribute :min_port_count
        attribute :port_count
        attribute :use_host_io_cache

        attr_accessor :machine

        def attach(medium, port, device = 0)
          requires :identity, :machine
          with_session do |session|
            session.machine.attach_device(identity, port, device, medium.device_type, medium.instance_variable_get(:@raw))
            session.machine.save_settings
          end
          true
        end

        def destroy
          requires :identity, :machine
          with_session do |session|
            session.machine.remove_storage_controller(identity)
            session.machine.save_settings
          end
          true
        end

        def save
          requires :bus, :identity, :machine
          with_session do |session|
            self.raw = session.machine.add_storage_controller(identity, bus)
            raw.port_count = 1
            session.machine.save_settings
          end
          true
        end

        private

        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw
          raw_attributes = {}
          # TODO: pending my patches being accepted :bootable, 
          for key in [:bus, :controller_type, :instance, :max_devices_per_port_count, :max_port_count, :min_port_count, :port_count, :use_host_io_cache]
            raw_attributes[key] = @raw.send(key)
          end
          merge_attributes(raw_attributes)
        end

        def session
          ::VirtualBox::Lib.lib.session
        end

        def with_session
          raw_machine = machine.instance_variable_get(:@raw)
          raw_machine.lock_machine(session, :write)
          yield session
          session.unlock_machine
        end

      end

    end
  end

end
