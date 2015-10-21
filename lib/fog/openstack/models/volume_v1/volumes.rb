require 'fog/openstack/models/collection'
require 'fog/openstack/models/volume_v1/volume'
require 'fog/openstack/models/volume/volumes'

module Fog
  module Volume
    class OpenStack
      class V1
        class Volumes < Fog::OpenStack::Collection
          model Fog::Volume::OpenStack::V1::Volume
          include Fog::Volume::OpenStack::Volumes
        end
      end
    end
  end
end
