require 'fog/ecloud/models/compute/operating_system_family'

module Fog
  module Compute
    class Ecloud
      class OperatingSystemFamilies < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::OperatingSystemFamily

        def all
          data = service.get_operating_system_families(href).body[:OperatingSystemFamily]
          load(data)
        end

        def get(uri)
          if data = service.get_operating_system(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
