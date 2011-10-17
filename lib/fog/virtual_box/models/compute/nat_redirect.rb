require 'fog/core/model'

module Fog
  module Compute
    class VirtualBox

      class NATRedirect < Fog::Model

        identity :name

        attribute :name
        attribute :protocol
        attribute :host_ip
        attribute :host_port
        attribute :guest_ip
        attribute :guest_port

        attr_accessor :machine, :nat_engine

        def destroy
          requires :nat_engine, :name
          with_session do |session|
            raw_network_adapter = session.machine.get_network_adapter(nat_engine.network_adapter.slot)
            raw_nat_engine = raw_network_adapter.nat_driver
            raw_nat_engine.remove_redirect(name)
            session.machine.save_settings
          end
          true
        end

        def initialize(attributes = {})
          self.name     = ''
          self.protocol = :tcp
          self.host_ip  = ''
          self.guest_ip = ''
          super
        end

        undef_method :protocol=
        def protocol=(new_protocol)
          attributes[:protocol] = case new_protocol
          when '0'
            :udp
          when '1'
            :tcp
          else
            new_protocol
          end
        end

        def save
          requires :nat_engine, :name, :protocol, :host_ip, :host_port, :guest_ip, :guest_port
          with_session do |session|
            raw_network_adapter = session.machine.get_network_adapter(nat_engine.network_adapter.slot)
            raw_nat_engine = raw_network_adapter.nat_driver
            raw_nat_engine.add_redirect(name, protocol, host_ip, host_port, guest_ip, guest_port)
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
          name, protocol, host_ip, host_port, guest_ip, guest_port = new_raw.split(',')
          raw_attributes = {:name => name, :protocol => protocol, :host_ip => host_ip, :host_port => host_port, :guest_ip => guest_ip, :guest_port => guest_port}
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
