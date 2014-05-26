require 'fog/core/collection'
require 'fog/openstack/models/compute/volume'

module Fog
  module Compute
    class OpenStack
      class Volumes < Fog::Collection
        model Fog::Compute::OpenStack::Volume

        def all(detailed=true)
          load(service.list_volumes(detailed).body['volumes'])
        end

        def get(volume_id)
          if volume = service.get_volume_details(volume_id).body['volume']
            new(volume)
          end
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
