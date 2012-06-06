require 'fog/ecloudv2/models/compute/hardware_configuration'

module Fog
  module Compute
    class Ecloudv2
      class HardwareConfigurations < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::HardwareConfiguration

        def all
          data = connection.get_hardware_configurations(href).body
          load(data)
        end

        def get(uri)
          if data = connection.get_hardware_configuration(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
