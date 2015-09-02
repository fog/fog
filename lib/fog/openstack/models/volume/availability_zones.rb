require 'fog/openstack/models/collection'
require 'fog/openstack/models/volume/availability_zone'

module Fog
  module Volume
    class OpenStack
      class AvailabilityZones < Fog::OpenStack::Collection
        model Fog::Volume::OpenStack::AvailabilityZone

        def all(options = {})
          data = service.list_zones(options)
          load_response(data, 'availabilityZoneInfo')
        end
      end
    end
  end
end
