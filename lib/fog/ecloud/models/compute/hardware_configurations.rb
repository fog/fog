require 'fog/ecloud/models/compute/hardware_configuration'

module Fog
  module Compute
    class Ecloud
      class HardwareConfigurations < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::HardwareConfiguration

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
