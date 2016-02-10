require 'fog/openstack/models/collection'
require 'fog/openstack/models/volume_v2/availability_zone'
require 'fog/openstack/models/volume/availability_zones'

module Fog
  module Volume
    class OpenStack
      class V2
        class AvailabilityZones < Fog::OpenStack::Collection
          model Fog::Volume::OpenStack::V2::AvailabilityZone
          include Fog::Volume::OpenStack::AvailabilityZones
        end
      end
    end
  end
end
