require 'fog/core/collection'
require 'fog/openstack/models/volume/volume'

module Fog
  module Volume
    class OpenStack

      class Volumes < Fog::Collection
        model Fog::Volume::OpenStack::Volume

        def all(detailed=true)
          load(connection.list_volumes(detailed).body['volumes'])
        end

        def find_by_id(volume_id)
          if volume = connection.get_volume_details(volume_id).body['volume']
            new(volume)
          end
        rescue Fog::Volume::OpenStack::NotFound
          nil
        end
      end

    end
  end
end

