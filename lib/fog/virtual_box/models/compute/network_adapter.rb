require 'fog/core/model'
require 'fog/virtual_box/models/compute/nat_engine'

module Fog
  module Compute
    class VirtualBox

      class NetworkAdapter < Fog::Model

        identity :slot

        attribute :adapter_type
        attribute :attachment_type
        attribute :bandwidth_limit
        attribute :boot_priority
        attribute :cable_connected
        attribute :enabled
        attribute :host_interface
        attribute :internal_network
        attribute :line_speed
        attribute :mac_address
        attribute :nat_driver
        attribute :nat_network
        attribute :trace_enabled
        attribute :trace_file
        attribute :vde_network

        attr_accessor :machine

        def save
          with_session do |session|
            session_raw = session.machine.get_network_adapter(slot)
            # for attribute in [:adapter_type, :bandwidth_limit, :boot_priority, :cable_connected, :enabled, :host_interface, :internal_network, :line_speed, :mac_address, :nat_network, :trace_enabled, :trace_file]
            #   session_raw.send("#{attribute}=", attributes[attribute])
            # end
            session_raw.mac_address = mac_address
            session.machine.save_settings
          end
        end

        undef_method :nat_driver
        def nat_driver
          Fog::Compute::VirtualBox::NATEngine.new(
            :connection       => connection,
            :machine          => machine,
            :network_adapter  => self,
            :raw              => raw.nat_driver
          )
        end

        private

        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw
          raw_attributes = {}
          for key in [:adapter_type, :attachment_type, :bandwidth_limit, :boot_priority, :cable_connected, :enabled, :host_interface, :internal_network, :line_speed, :mac_address, :nat_driver, :nat_network, :slot, :trace_enabled, :trace_file]
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
