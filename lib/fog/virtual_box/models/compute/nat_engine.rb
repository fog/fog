require 'fog/core/model'

module Fog
  module Compute
    class VirtualBox

      class NATEngine < Fog::Model

        # identity :?

        attribute :alias_mode
        attribute :dns_pass_domain
        attribute :dns_proxy
        attribute :dns_use_host_resolver
        attribute :host_ip
        attribute :network
        attribute :redirects
        attribute :tftp_boot_file
        attribute :tftp_next_server
        attribute :tftp_prefix

        attr_accessor :machine, :network_adapter

        # def save
        #   unless identity
        #     requires :identity, :bus, :machine
        #     with_session do |session|
        #       self.raw = session.machine.add_storage_controller(identity, bus)
        #     end
        #     true
        #   else
        #     raise Fog::Errors::Error.new('Updating an existing storage_controller is not yet implemented. Contributions welcome!')
        #   end
        # end

        undef_method :redirects
        def redirects
          Fog::Compute::VirtualBox::NATRedirects.new(
            :connection => connection,
            :machine    => machine,
            :nat_engine => self
          )
        end

        private

        def raw
          @raw
        end
        
        def raw=(new_raw)
          @raw = new_raw
          raw_attributes = {}
          for key in [:alias_mode, :dns_pass_domain, :dns_proxy, :dns_use_host_resolver, :host_ip, :network, :redirects, :tftp_boot_file, :tftp_next_server, :tftp_prefix]
            raw_attributes[key] = @raw.send(key)
          end
          merge_attributes(raw_attributes)
        end

      end

    end
  end

end
