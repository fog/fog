require 'fog/openstack/models/collection'
require 'fog/openstack/models/volume_v2/volume_type'
require 'fog/openstack/models/volume/volume_types'

module Fog
  module Volume
    class OpenStack
      class V2
        class VolumeTypes < Fog::OpenStack::Collection
          model Fog::Volume::OpenStack::V2::VolumeType
          include Fog::Volume::OpenStack::VolumeTypes
        end
      end
    end
  end
end
