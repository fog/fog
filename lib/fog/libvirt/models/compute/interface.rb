require 'fog/core/model'

module Fog
  module Compute
    class Libvirt

      class Interface < Fog::Model

        identity :name
        attribute :mac
        attribute :active

        def save
          raise Fog::Errors::Error.new('Creating a new interface is not yet implemented. Contributions welcome!')
        end

        def shutdown
          connection.destroy_interface(mac)
        end

        def active?
          active
        end
      end

    end
  end
end
