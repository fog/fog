require 'fog/openstack/models/volume/volume_type'

module Fog
  module Volume
    class OpenStack
      class V1
        class VolumeType < Fog::Volume::OpenStack::VolumeType
          identity :id

          attribute :name
          attribute :volume_backend_name
        end
      end
    end
  end
end
