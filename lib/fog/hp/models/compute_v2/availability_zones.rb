require 'fog/core/collection'
require 'fog/hp/models/compute_v2/availability_zone'

module Fog
  module Compute
    class HPV2
      class AvailabilityZones < Fog::Collection
        model Fog::Compute::HPV2::AvailabilityZone

        def all
          data = service.list_availability_zones.body['availabilityZoneInfo']
          load(data)
        end

        def get(zone_name)
          if zone_name
            self.all.select {|z| z.name == zone_name}.first
          end
        rescue Fog::Compute::HPV2::NotFound
          nil
        end
      end
    end
  end
end
