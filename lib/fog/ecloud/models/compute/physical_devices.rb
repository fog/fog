require 'fog/ecloud/models/compute/physical_device'

module Fog
  module Compute
    class Ecloud
      class PhysicalDevices < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::PhysicalDevice

        def all
          data = service.get_physical_devices(href).body[:PhysicalDevice] || []
          load(data)
        end

        def get(uri)
          if data = service.get_physical_device(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
