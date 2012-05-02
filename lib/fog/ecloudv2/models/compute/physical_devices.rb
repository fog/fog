require 'fog/ecloudv2/models/compute/physical_device'

module Fog
  module Compute
    class Ecloudv2
      class PhysicalDevices < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::PhysicalDevice

        def all
          data = connection.get_physical_devices(href).body[:PhysicalDevice] || []
          load(data)
        end

        def get(uri)
          if data = connection.get_physical_device(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
