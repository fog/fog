require 'fog/ecloudv2/models/compute/operating_system_family'

module Fog
  module Compute
    class Ecloudv2
      class OperatingSystemFamilies < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::OperatingSystemFamily

        def all
          data = connection.get_operating_system_families(href).body[:OperatingSystemFamily]
          load(data)
        end

        def get(uri)
          if data = connection.get_operating_system(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
