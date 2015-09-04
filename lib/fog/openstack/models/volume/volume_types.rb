require 'fog/openstack/models/collection'
require 'fog/openstack/models/volume/volume_type'

module Fog
  module Volume
    class OpenStack
      class VolumeTypes < Fog::OpenStack::Collection
        model Fog::Volume::OpenStack::VolumeType

        def all(options = {})
          response = service.list_volume_types(options)
          load_response(response, 'volume_types')
        end

        def get(volume_type_id)
          if volume_type = service.get_volume_type_details(volume_type_id).body['volume_type']
            new(volume_type)
          end
        rescue Fog::Volume::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
