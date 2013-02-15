require 'fog/ecloud/models/compute/hardware_configuration'

module Fog
  module Compute
    class Ecloud
      class HardwareConfigurations < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::HardwareConfiguration

        def all
          data = service.get_server(href).body
          load(data)
        end

        def get(uri)
          if data = service.get_hardware_configuration(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
