require 'fog/core/collection'
require 'fog/virtual_box/models/compute/network_adapter'

module Fog
  module Compute
    class VirtualBox

      class NetworkAdapters < Fog::Collection

        model Fog::Compute::VirtualBox::NetworkAdapter

        attr_accessor :machine

        def all
          requires :machine
          data = []
          raw_machine = machine.instance_variable_get(:@raw)
          connection.system_properties.network_adapter_count.times do |index|
            data << {
              :raw  => raw_machine.get_network_adapter(index)
            }
          end
          load(data)
        end

        def get(network_adapter_slot)
          requires :machine
          raw_machine = machine.instance_variable_get(:@raw)
          network_adapter = raw_machine.get_network_adapter(network_adapter_slot)
          new(:raw => network_adapter)
        end

        def new(attributes = {})
          requires :machine
          super({ :machine => machine }.merge!(attributes))
        end

      end

    end
  end
end
